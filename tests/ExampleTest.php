<?php

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{
  // Test true example
  public function testTrue(){
    $this->assertTrue(true);
  }

  // Test false example
  public function testFalse(){
    $this->assertFalse(false);
  }

  // Test equals -> verifica iguales (==)
  public function testEquals(){
    $var = 5+5;
    $this->assertEquals($var, "10");
  }

  // Test same -> verifica idénticos (===)
  public function testSame(){
    $var = 5+5;
    $this->assertSame($var, 10);
  }

  /*
  Verifiación tipos de datos
    assertIsBool
    assertIsInt
    assertIsString
    assertIsArray
  */

  // Ejemplo Test array
  public function testArray(){
    $this->assertIsArray([]);
  }

  // Test empty
  public function testEmpty(){
    $this->assertEmpty([]);
  }
  
  // Test count
  public function testCount(){
    $arrCount = ["Element1", "Element2"];
    $this->assertCount(2, $arrCount);
  }

  // Test has key
  public function testHasKey(){
    $arrKey = ["testkey" => "exite"];
    $this->assertArrayHasKey("testkey", $arrKey );
  }

}