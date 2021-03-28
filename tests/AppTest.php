<?php

use PHPUnit\Framework\TestCase;
use App\App;

class AppTest extends TestCase
{
  public function test_sayHello(): void
  {
    $hello = new App("Marc");

    self::assertEquals($hello->sayHello(), "Hello Marc!");
  }
}