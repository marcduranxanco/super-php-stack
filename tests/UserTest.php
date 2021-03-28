<?php

use PHPUnit\Framework\TestCase;
use App\User;

class UserTest extends TestCase{

    protected $user;

    public function setUp() :void{
        $this->user = new User("Juan", "Fernandex");
    }

    public function test_can_get_name(){
        $this->user->setName("Marc");
        $this->assertSame("Marc", $this->user->getName());
    }

    public function test_can_get_surName(){
        $this->user->setSurname("Duran");
        $this->assertSame("Duran", $this->user->getSurname());
    }
}