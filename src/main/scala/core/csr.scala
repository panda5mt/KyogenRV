// See README.md for license details.

package core

import chisel3._
import chisel3.iotesters._
import chisel3.util._

import chisel3.Clock

import scala.io.{BufferedSource, Source}
import _root_.core.ScalarOpConstants._
import MemoryOpConstants._
import bus.{HostIf, TestIf}
import mem._

object CSR
{
  // commands
  val SZ = 3.W
  val X = 0.U(SZ)
  val N = 0.U(SZ)
  val W = 1.U(SZ)
  val S = 2.U(SZ)
  val C = 3.U(SZ)
  val I = 4.U(SZ)
  val R = 5.U(SZ)

}