-------------------------------------------------------------------------------
--
-- File: IoLogic.vhd
-- Author: NI
-- Original Project: NI6569
-- Date: 28th April 2020
--
-------------------------------------------------------------------------------
-- Copyright © 2021 National Instruments Corporation.
--
-- You may only modify and distribute this file as expressly permitted in the
-- Software License Agreement provided with this software.  Without limiting
-- any of the provisions in that license agreement, you may only distribute
-- modified versions of this file to end-users who you have verified have a
-- valid license to the NI FlexRIO software, and you restrict from using the
-- file for any purpose other than the customization of the FPGA functionality
-- of NI FPGA-enabled hardware or hardware targets specifically designated by
-- NI in writing.
-------------------------------------------------------------------------------
--
-- Purpose:
--  This file populates the I/O Buffers for LVDS and SE IOs.
--  It is common across all NI6569 variants.
--  The direction of the buffers is defined Pinsmapping file of each
--  NI6569 variant.
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library unisim;
  use unisim.vcomponents.all;

entity IoLogic is
  generic (
    kDataWidth : integer  := 32
  );
  port (
    -- Adapter Module I/O
    aGpio_p                : inout std_logic_vector(kDataWidth-1 downto 0);
    aGpio_n                : inout std_logic_vector(kDataWidth-1 downto 0);
    aGpioFpgaBufOe         : in std_logic_vector(kDataWidth-1 downto 0);
    aSeGpio                : inout std_logic_vector(15 downto 0);
    aSeFpgaBufOe           : in std_logic_vector(7 downto 0);
    -- Logical signal names
    aDiffInputFromFpgaBuf  : out std_logic_vector(kDataWidth-1 downto 0);
    aDiffOutputToFpgaBuf   : in std_logic_vector(kDataWidth-1 downto 0);
    aSeInputFromFpgaBuf    : out std_logic_vector(7 downto 0);
    aSeOutputToFpgaBuf     : in std_logic_vector(7 downto 0);
    aExtSeBufDir           : in std_logic_vector(7 downto 0)
    );
end entity IoLogic;

architecture rtl of IoLogic is

  --vhook_sigstart
  --vhook_sigend

begin

  -------------------------------------------
  -- Bidirectional Differential Buffers
  --------------------------------------------
  AcqGenData_DIFFIOBUF: for i in 0 to kDataWidth-1 generate
    --vhook_i IOBUFDS IOBUFx
    --vhook_a IO  aGpio_p(i)
    --vhook_a IOB aGpio_n(i)
    --vhook_a O   aDiffInputFromFpgaBuf(i)
    --vhook_a I   aDiffOutputToFpgaBuf(i)
    --vhook_a T   not aGpioFpgaBufOe(i)
    IOBUFx: IOBUFDS
      port map (
        IO  => aGpio_p(i),                --inout std_logic
        IOB => aGpio_n(i),                --inout std_logic
        T   => not aGpioFpgaBufOe(i),     --in  std_logic
        I   => aDiffOutputToFpgaBuf(i),   --in  std_logic
        O   => aDiffInputFromFpgaBuf(i)); --out std_logic
  end generate AcqGenData_DIFFIOBUF;

  -------------------------------------------
  -- Bidirectional Single Ended Buffers
  --------------------------------------------
  AcqGenData_SEIOBUF: for i in 0 to 7 generate
    -- FOR ODD SEGPIO
    --vhook_i IOBUF SEIOBUFx
    --vhook_g DRIVE          12
    --vhook_g IBUF_LOW_PWR   TRUE
    --vhook_g IOSTANDARD     "LVCMOS18"
    --vhook_g SLEW           "FAST"
    --vhook_a IO             aSeGpio((2*i)+1)
    --vhook_a O              aSeInputFromFpgaBuf(i)
    --vhook_a I              aSeOutputToFpgaBuf(i)
    --vhook_a T              not aSeFpgaBufOe(i)
    SEIOBUFx: IOBUF
      generic map (
        DRIVE        => 12,          --integer:=12
        IBUF_LOW_PWR => TRUE,        --boolean:=TRUE
        IOSTANDARD   => "LVCMOS18",  --string:="DEFAULT"
        SLEW         => "FAST")      --string:="SLOW"
      port map (
        O  => aSeInputFromFpgaBuf(i),  --out std_ulogic
        IO => aSeGpio((2*i)+1),        --inout std_ulogic
        I  => aSeOutputToFpgaBuf(i),   --in  std_ulogic
        T  => not aSeFpgaBufOe(i));    --in  std_ulogic

    -- FOR EVEN SEGPIO
    aSeGpio(2*i) <= aExtSeBufDir(i);

  end generate AcqGenData_SEIOBUF;

end rtl;