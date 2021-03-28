<?php

declare(strict_types=1);

namespace App;

class App
{

    protected $nombre;

    public function __construct($nombre)
    {
        $this->nombre = $nombre;
    }

    public function sayHello(): string
    {
        $hello = "Hello $this->nombre!";
        return $hello;
    }
}
