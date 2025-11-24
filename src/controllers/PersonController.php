<?php

namespace App\Controllers;

use App\Person;

class PersonController
{
    public function create()
    {
        $person = new Person();
        $person->first_name = htmlspecialchars($_POST['first_name']);
        $person->last_name = htmlspecialchars($_POST['last_name']);
        $person->email = htmlspecialchars($_POST['email']);
        return $person;
    }
}
