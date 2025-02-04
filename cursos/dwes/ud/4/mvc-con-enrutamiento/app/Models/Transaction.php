<?php
namespace App\Models;

use Database\DB;

class Transaction
{
    private $id;
    private $type;
    private $amount;
    private $date;

    public function __construct($id = null, $type = '', $amount = 0.0, $date = '')
    {
        $this->id = $id;
        $this->type = $type;
        $this->amount = $amount;
        $this->date = $date;
    }

    public function getId()
    {
        return $this->id;
    }

    public function getType()
    {
        return $this->type;
    }

    public function getAmount()
    {
        return $this->amount;
    }

    public function getDate()
    {
        return $this->date;
    }

    public function setType(string $type)
    {
        $this->type = $type;
    }

    public function setAmount(float $amount)
    {
        $this->amount = $amount;
    }

    public function setDate($date)
    {
        $this->date = $date;
    }

    public function create()
    {
        $db = new DB();

        $sql = 'INSERT INTO transactions (type, amount, date) VALUES (:type, :amount, :date)';

        $db->prepare($sql);

        $db->bind(':type', $this->type);
        $db->bind(':amount', $this->amount);
        $db->bind(':date', $this->date);

        return $db->execute();
    }

    public function read(int $id)
    {
        $db = new DB();

        $sql = 'SELECT * FROM transactions WHERE id = :id';

        $db->prepare($sql);
        $db->bind(':id', $id);

        $db->execute();

        $transaction = $db->fetch();

        $this->id = $transaction['id'];
        $this->type = $transaction['type'];
        $this->amount = $transaction['amount'];
        $this->date = $transaction['date'];

        return $this;
    }

    public static function readAll()
    {
        $db = new DB();

        $sql = 'SELECT * FROM transactions ORDER BY id DESC';

        $db->prepare($sql);
        $db->execute();

        return $db->fetchAll();
    }

    public function update()
    {
        $db = new DB();

        $sql = 'UPDATE transactions SET type = :type, amount = :amount, date = :date WHERE id = :id';

        $db->prepare($sql);

        $db->bind(':id', $this->id);
        $db->bind(':type', $this->type);
        $db->bind(':amount', $this->amount);
        $db->bind(':date', $this->date);

        return $db->execute();
    }

    public function delete()
    {
        $db = new DB();

        $sql = 'DELETE FROM transactions WHERE id = :id';

        $db->prepare($sql);
        $db->bind(':id', $this->id);

        return $db->execute();
    }
}
