// By Trenton Isenor

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;

public class Enemy : Character
{
    //variables
    public Transform[] patrolPoints;
    public NavMeshAgent enemy;

    public int tunnelVision;//rayRange
    public int awareness; //hearing / detecting range
    public int attackDelay;
    [Header("For Health bar")]
    public Image healthBar;
    public GameObject canvas;
    public Transform camera;
    public bool isGuard;

    protected Character targetScript;
    protected int originAwareness;
    protected float originSpeed;
    protected int maxAwareness;
    protected float maxSpeed;


    //9 states
    protected enum State
    {
        patrolling,
        chasing,
        searching,
        attacking,
        retreating,
        fleeing,
        resting,
        guarding,
        dead
    }
    protected State state;

    protected float distanceBetweenTarget;
    protected Vector3 targetLastKnownPos;

    protected int patrolDestination;
    private int patrolPointAmount = 16;

    private bool isGettingBumped;
    private Ray ray;
    private RaycastHit rayHit;
    private int nextAttackDelay;
    private Vector3 originPos;
    private Vector3 originRot;
    private float originSize;

    // Start is called before the first frame update
    void Start()
    {
        //enemy crouching has not been implemented yet
        crouching = false;
        //sets max variables
        nextHealCoolDown = healingCoolDown;
        //retrieves rigidbody for you
        rb = this.gameObject.GetComponent<Rigidbody>();
        nextAttackDelay = attackDelay;
        //position/rotation for guards
        originPos = this.transform.position;
        originRot = this.transform.eulerAngles;
        maxHealth = health;
        //is not dead on spawn
        isDead = false;
        //original speed and awareness because these variables are doubled when chasing so they need to return to original value afterwards
        originSpeed = enemy.speed;
        originAwareness = awareness;
        //more max vairables
        maxAwareness = awareness * 2;
        maxSpeed = enemy.speed * 2;

        originSize = healthBar.rectTransform.sizeDelta.x;
        ray = new Ray(this.transform.position, this.transform.forward);

        enemy = GetComponent<NavMeshAgent>();
        //resets patrol position
        patrolDestination = 0;
        //TIPOFF
        if (isGuard == true) { state = State.guarding; }
        else { state = State.patrolling; }
    }

    // Update is called once per frame
    //STATE MACHINE
    void Update()
    {
        distanceBetweenHomeBase = Vector3.Distance(homeBase.transform.position, this.transform.position);
        healthBar.rectTransform.sizeDelta = new Vector2(originSize * health / maxHealth, healthBar.rectTransform.sizeDelta.y);
        canvas.transform.LookAt(canvas.transform.position + camera.forward);
        Debug.Log(state);
        if (isDead == true && state != State.dead){state = State.dead;}
        //will not calculate distance between target if target is not defined......
        if (target != null && isDead == false){distanceBetweenTarget = Vector3.Distance(enemy.transform.position, target.transform.position);}

        switch (state)
        {
            case State.patrolling:
                Patrol();
                break;
            case State.fleeing:
                Flee();
                break;
            case State.resting:
                Rest();
                break;
            case State.attacking:
                attack();
                break;
            case State.chasing:
                Chase();
                break;
            case State.searching:
                Search();
                break;
            case State.retreating:
                Retreat();
                break;
            case State.guarding:
                Guard();
                break;
            case State.dead:
                Die();
                break;
        }
    }

    //methods that go with states for simplicity
    public void Rest()
    {
        enemy.autoBraking = true;
        if (health >= maxHealth)
        {
            if (isGuard == true) { state = State.guarding; }
            else { state = State.retreating; }
        }
        if (Time.time > nextHealCoolDown)
        {
            Heal(maxHealth / 4);
            nextHealCoolDown = Mathf.RoundToInt(Time.time) + healingCoolDown;
        }
        else if (distanceBetweenHomeBase <= actionDistance && health < maxHealth) { state = State.resting; }
        if (isGettingBumped == true) { state = State.attacking; }
    }
    public void Flee()
    {
        enemy.autoBraking = false;
        enemy.SetDestination(homeBase.transform.position);
        if (distanceBetweenHomeBase <= actionDistance) { state = State.resting; }
    }
    public void Guard()
    {
        enemy.autoBraking = true;
        enemy.SetDestination(originPos);
        float originPosDistance = Vector3.Distance(originPos, enemy.transform.position);
        if (originPosDistance <= actionDistance) { enemy.transform.eulerAngles = originRot; }
        if (isGettingBumped == true) { isGettingBumped = false; state = State.attacking; }
        if (amAlmostDead() == true) { state = State.fleeing; }
        if (targetDetected() == true) { state = State.chasing; }
        if (targetWithinRange() == true) { state = State.attacking; }
    }
    public void Die()
    {
        enemy.autoBraking = true;
        this.gameObject.transform.eulerAngles = new Vector3(90, transform.eulerAngles.y, transform.eulerAngles.z);
        this.gameObject.GetComponent<Collider>().enabled = false;
        this.gameObject.GetComponent<NavMeshAgent>().enabled = false;
        this.canvas.SetActive(false);
    }
    public void Patrol()
    {
        enemy.autoBraking = false;
        if (isGettingBumped == true) { isGettingBumped = false; state = State.attacking; }
        if (amAlmostDead() == true) { state = State.fleeing; }
        if (targetDetected() == true) { state = State.chasing; }
        if (targetWithinRange() == true) { state = State.attacking; }
        if (!enemy.pathPending && enemy.remainingDistance < actionDistance) {
            enemy.speed = originSpeed;
            awareness = originAwareness;
            if (patrolPoints.Length == 0) { enabled = false; return; }
            enemy.destination = patrolPoints[patrolDestination].position;
            patrolDestination = (patrolDestination + 1) % patrolPoints.Length;
        }
    }

    public void Retreat()
    {
        enemy.autoBraking = false;
        enemy.speed = originSpeed;
        awareness = originAwareness;
        enemy.SetDestination(patrolPoints[0].position);
        if (isGettingBumped == true) { isGettingBumped = false; state = State.attacking; }
        if (amAlmostDead() == true) { state = State.fleeing; }
        if (targetDetected() == true) { state = State.chasing; }
        if (targetWithinRange() == true) { state = State.attacking; }
        if (isGuard == true) { state = State.guarding; }
        else
        {
            float startDistance = Vector3.Distance(patrolPoints[0].position, enemy.transform.position);
            if (startDistance <= actionDistance) { state = State.patrolling; }
        }

    }
    public void Chase()
    {
        enemy.autoBraking = false;
        if (target != null && targetScript != null && targetScript.isDead == true) { state = State.retreating; }
        if (isGettingBumped == true) { isGettingBumped = false; state = State.attacking; }
        if (amAlmostDead() == true) { state = State.fleeing; }
        if (targetDetected() == true) {
            enemy.speed = maxSpeed;
            awareness = maxAwareness;
            targetLastKnownPos = target.transform.position;
            enemy.SetDestination(targetLastKnownPos);
        }
        if (targetWithinRange() == true) { state = State.attacking; }
        if (target != null && targetScript != null && targetScript.isDead == false)
        {
            if (distanceBetweenTarget > awareness && rayHit.transform.gameObject != target) { state = State.searching; }
        }
    }
    public void Search()
    {
        enemy.autoBraking = false;
        enemy.speed = originSpeed;
        awareness = originAwareness;
        enemy.SetDestination(targetLastKnownPos);
        float searchDistance = Vector3.Distance(targetLastKnownPos, enemy.transform.position);
        if (searchDistance <= actionDistance) { state = State.retreating; }
        if (isGettingBumped == true) { isGettingBumped = false; state = State.attacking; }
        if (amAlmostDead() == true) { state = State.fleeing; }
        if (targetDetected() == true) { state = State.chasing; }
        if (targetWithinRange() == true) { state = State.attacking; }
    }
    public void attack()
    {
        enemy.autoBraking = true;
        if (targetScript.isDead == true)
        {
            if (isGuard == true) { state = State.guarding; }
            else { state = State.retreating; }
        }
        else
        {
            if (Time.time > nextAttackDelay)
            {
                targetScript.TakeDamage(this.attackDamage);
                nextAttackDelay = Mathf.RoundToInt(Time.time) + attackDelay;
            }
            if (target != null) { if (distanceBetweenTarget >= actionDistance) { state = State.chasing; } }
        }
        if (isGettingBumped == true) { isGettingBumped = false; state = State.attacking; }
        if (amAlmostDead() == true) { state = State.fleeing; }
        if (targetDetected() == true) { state = State.chasing; }
    }
    public bool amAlmostDead()
    {
        if (health <= (maxHealth / 4)){return true;}
        else{return false;}
    }
    public bool targetWithinRange()
    {
        if (target != null)
        {
            if (distanceBetweenTarget <= actionDistance)
            {
                if (target.tag != "NonTarget" && target.tag != this.gameObject.tag && targetScript.crouching == false && targetScript.isDead == false){return true;}
            }
        }
        return false;
    }
    public bool targetDetected()
    {
        if (Physics.Raycast(transform.position, transform.forward, out rayHit, tunnelVision))
        {
            if (rayHit.transform.gameObject.tag != "NonTarget" && rayHit.transform.gameObject.tag != this.gameObject.tag)
            {
                //Debug.Log("AYOOO");
                target = rayHit.transform.gameObject;
                targetScript = target.GetComponent<Character>();
                if (distanceBetweenTarget > actionDistance && targetScript.isDead == false && state != State.fleeing){return true;}
            }
        }

        if (target != null)
        {
            if (distanceBetweenTarget <= awareness && distanceBetweenTarget > actionDistance)
            {
                if (target.tag != "NonTarget" && target.tag != this.gameObject.tag && targetScript.isDead == false && state != State.fleeing && isGettingBumped == true) { return true; }
                else if (target.tag != "NonTarget" && target.tag != this.gameObject.tag && targetScript.crouching == false && targetScript.isDead == false && state != State.fleeing){return true;}
            }
        }
        return false;
    }
    //targeting system
    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag != "NonTarget" && other.gameObject.tag != this.gameObject.tag && isDead == false)
        {
            target = other.gameObject;
            targetScript = target.GetComponent<Character>();
        }
    }
    //if a possible target hits enemy, enemy will be alerted and decide on how deal with it
    public void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.tag != "NonTarget" && other.gameObject.tag != this.gameObject.tag && isDead == false)
        {
            target = other.gameObject;
            targetScript = target.GetComponent<Character>();
            isGettingBumped = true;
        }
    }
}
