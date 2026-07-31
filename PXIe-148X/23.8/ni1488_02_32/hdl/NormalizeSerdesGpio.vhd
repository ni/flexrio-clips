-------------------------------------------------------------------------------
--
-- File: NormalizeSerdesGpio.vhd
-- Author: Neil Klug
-- Original Project: NI 148X
-- Date: 25 June 2020
--
-------------------------------------------------------------------------------
-- (c) 2020 Copyright National Instruments.
-- All Rights Reserved
-- National Instruments Internal Information
-------------------------------------------------------------------------------
--
-- Purpose:
--    Take the individual Serdes GPIO signals to/from the CLIP and bundle them
--    up into SLVs for use by the FixedLogic.
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity NormalizeSerdesGpio is
  port(
    -- Normalized GPIO
    sDiagramCh0GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh0GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh0GpOe   : out std_logic_vector(7 downto 0);
    sDiagramCh1GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh1GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh1GpOe   : out std_logic_vector(7 downto 0);
    sDiagramCh2GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh2GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh2GpOe   : out std_logic_vector(7 downto 0);
    sDiagramCh3GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh3GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh3GpOe   : out std_logic_vector(7 downto 0);
    sDiagramCh4GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh4GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh4GpOe   : out std_logic_vector(7 downto 0);
    sDiagramCh5GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh5GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh5GpOe   : out std_logic_vector(7 downto 0);
    sDiagramCh6GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh6GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh6GpOe   : out std_logic_vector(7 downto 0);
    sDiagramCh7GpIn   : in  std_logic_vector(7 downto 0);
    sDiagramCh7GpOut  : out std_logic_vector(7 downto 0);
    sDiagramCh7GpOe   : out std_logic_vector(7 downto 0);
    sDiagramMiscGpIn  : in  std_logic_vector(15 downto 0);
    sDiagramMiscGpOut : out std_logic_vector(15 downto 0);
    sDiagramMiscGpOe  : out std_logic_vector(15 downto 0);

    -- Individual Serdes GPIO
    sDiagramSer0Gp0In  : out std_logic;
    sDiagramSer0Gp0Out : in  std_logic;
    sDiagramSer0Gp0Oe  : in  std_logic;
    sDiagramSer0Gp1In  : out std_logic;
    sDiagramSer0Gp1Out : in  std_logic;
    sDiagramSer0Gp1Oe  : in  std_logic;
    sDiagramSer0Gp2In  : out std_logic;
    sDiagramSer0Gp2Out : in  std_logic;
    sDiagramSer0Gp2Oe  : in  std_logic;
    sDiagramSer0Gp3In  : out std_logic;
    sDiagramSer0Gp3Out : in  std_logic;
    sDiagramSer0Gp3Oe  : in  std_logic;
    sDiagramSer1Gp0In  : out std_logic;
    sDiagramSer1Gp0Out : in  std_logic;
    sDiagramSer1Gp0Oe  : in  std_logic;
    sDiagramSer1Gp1In  : out std_logic;
    sDiagramSer1Gp1Out : in  std_logic;
    sDiagramSer1Gp1Oe  : in  std_logic;
    sDiagramSer1Gp2In  : out std_logic;
    sDiagramSer1Gp2Out : in  std_logic;
    sDiagramSer1Gp2Oe  : in  std_logic;
    sDiagramSer1Gp3In  : out std_logic;
    sDiagramSer1Gp3Out : in  std_logic;
    sDiagramSer1Gp3Oe  : in  std_logic;
    sDiagramSer2Gp0In  : out std_logic;
    sDiagramSer2Gp0Out : in  std_logic;
    sDiagramSer2Gp0Oe  : in  std_logic;
    sDiagramSer2Gp1In  : out std_logic;
    sDiagramSer2Gp1Out : in  std_logic;
    sDiagramSer2Gp1Oe  : in  std_logic;
    sDiagramSer2Gp2In  : out std_logic;
    sDiagramSer2Gp2Out : in  std_logic;
    sDiagramSer2Gp2Oe  : in  std_logic;
    sDiagramSer2Gp3In  : out std_logic;
    sDiagramSer2Gp3Out : in  std_logic;
    sDiagramSer2Gp3Oe  : in  std_logic;
    sDiagramSer3Gp0In  : out std_logic;
    sDiagramSer3Gp0Out : in  std_logic;
    sDiagramSer3Gp0Oe  : in  std_logic;
    sDiagramSer3Gp1In  : out std_logic;
    sDiagramSer3Gp1Out : in  std_logic;
    sDiagramSer3Gp1Oe  : in  std_logic;
    sDiagramSer3Gp2In  : out std_logic;
    sDiagramSer3Gp2Out : in  std_logic;
    sDiagramSer3Gp2Oe  : in  std_logic;
    sDiagramSer3Gp3In  : out std_logic;
    sDiagramSer3Gp3Out : in  std_logic;
    sDiagramSer3Gp3Oe  : in  std_logic;
    sDiagramSer4Gp0In  : out std_logic;
    sDiagramSer4Gp0Out : in  std_logic;
    sDiagramSer4Gp0Oe  : in  std_logic;
    sDiagramSer4Gp1In  : out std_logic;
    sDiagramSer4Gp1Out : in  std_logic;
    sDiagramSer4Gp1Oe  : in  std_logic;
    sDiagramSer4Gp2In  : out std_logic;
    sDiagramSer4Gp2Out : in  std_logic;
    sDiagramSer4Gp2Oe  : in  std_logic;
    sDiagramSer4Gp3In  : out std_logic;
    sDiagramSer4Gp3Out : in  std_logic;
    sDiagramSer4Gp3Oe  : in  std_logic;
    sDiagramSer5Gp0In  : out std_logic;
    sDiagramSer5Gp0Out : in  std_logic;
    sDiagramSer5Gp0Oe  : in  std_logic;
    sDiagramSer5Gp1In  : out std_logic;
    sDiagramSer5Gp1Out : in  std_logic;
    sDiagramSer5Gp1Oe  : in  std_logic;
    sDiagramSer5Gp2In  : out std_logic;
    sDiagramSer5Gp2Out : in  std_logic;
    sDiagramSer5Gp2Oe  : in  std_logic;
    sDiagramSer5Gp3In  : out std_logic;
    sDiagramSer5Gp3Out : in  std_logic;
    sDiagramSer5Gp3Oe  : in  std_logic;
    sDiagramSer6Gp0In  : out std_logic;
    sDiagramSer6Gp0Out : in  std_logic;
    sDiagramSer6Gp0Oe  : in  std_logic;
    sDiagramSer6Gp1In  : out std_logic;
    sDiagramSer6Gp1Out : in  std_logic;
    sDiagramSer6Gp1Oe  : in  std_logic;
    sDiagramSer6Gp2In  : out std_logic;
    sDiagramSer6Gp2Out : in  std_logic;
    sDiagramSer6Gp2Oe  : in  std_logic;
    sDiagramSer6Gp3In  : out std_logic;
    sDiagramSer6Gp3Out : in  std_logic;
    sDiagramSer6Gp3Oe  : in  std_logic;
    sDiagramSer7Gp0In  : out std_logic;
    sDiagramSer7Gp0Out : in  std_logic;
    sDiagramSer7Gp0Oe  : in  std_logic;
    sDiagramSer7Gp1In  : out std_logic;
    sDiagramSer7Gp1Out : in  std_logic;
    sDiagramSer7Gp1Oe  : in  std_logic;
    sDiagramSer7Gp2In  : out std_logic;
    sDiagramSer7Gp2Out : in  std_logic;
    sDiagramSer7Gp2Oe  : in  std_logic;
    sDiagramSer7Gp3In  : out std_logic;
    sDiagramSer7Gp3Out : in  std_logic;
    sDiagramSer7Gp3Oe  : in  std_logic      
  );
end NormalizeSerdesGpio;

architecture rtl of NormalizeSerdesGpio is

begin
  Ch0Gpio: process(sDiagramSer0Gp3Oe, sDiagramSer0Gp3Out, sDiagramCh0GpIn, sDiagramSer0Gp0Oe, sDiagramSer0Gp2Out,
    sDiagramSer0Gp0Out, sDiagramSer0Gp2Oe, sDiagramSer0Gp1Oe, sDiagramSer0Gp1Out) is
  begin
    sDiagramCh0GpOut <= (others => '0');
    sDiagramCh0GpOe  <= (others => '0');
    sDiagramSer0Gp0In   <= sDiagramCh0GpIn(0);
    sDiagramCh0GpOut(0) <= sDiagramSer0Gp0Out;
    sDiagramCh0GpOe(0)  <= sDiagramSer0Gp0Oe;
    sDiagramSer0Gp1In   <= sDiagramCh0GpIn(1);
    sDiagramCh0GpOut(1) <= sDiagramSer0Gp1Out;
    sDiagramCh0GpOe(1)  <= sDiagramSer0Gp1Oe;
    sDiagramSer0Gp2In   <= sDiagramCh0GpIn(2);
    sDiagramCh0GpOut(2) <= sDiagramSer0Gp2Out;
    sDiagramCh0GpOe(2)  <= sDiagramSer0Gp2Oe;
    sDiagramSer0Gp3In   <= sDiagramCh0GpIn(3);
    sDiagramCh0GpOut(3) <= sDiagramSer0Gp3Out;
    sDiagramCh0GpOe(3)  <= sDiagramSer0Gp3Oe;
  end process Ch0Gpio;

  Ch1Gpio: process(sDiagramCh1GpIn, sDiagramSer1Gp3Oe, sDiagramSer1Gp1Out, sDiagramSer1Gp0Oe, sDiagramSer1Gp3Out,
    sDiagramSer1Gp0Out, sDiagramSer1Gp1Oe, sDiagramSer1Gp2Out, sDiagramSer1Gp2Oe) is
  begin
    sDiagramCh1GpOut <= (others => '0');
    sDiagramCh1GpOe  <= (others => '0');
    sDiagramSer1Gp0In   <= sDiagramCh1GpIn(0);
    sDiagramCh1GpOut(0) <= sDiagramSer1Gp0Out;
    sDiagramCh1GpOe(0)  <= sDiagramSer1Gp0Oe;
    sDiagramSer1Gp1In   <= sDiagramCh1GpIn(1);
    sDiagramCh1GpOut(1) <= sDiagramSer1Gp1Out;
    sDiagramCh1GpOe(1)  <= sDiagramSer1Gp1Oe;
    sDiagramSer1Gp2In   <= sDiagramCh1GpIn(2);
    sDiagramCh1GpOut(2) <= sDiagramSer1Gp2Out;
    sDiagramCh1GpOe(2)  <= sDiagramSer1Gp2Oe;
    sDiagramSer1Gp3In   <= sDiagramCh1GpIn(3);
    sDiagramCh1GpOut(3) <= sDiagramSer1Gp3Out;
    sDiagramCh1GpOe(3)  <= sDiagramSer1Gp3Oe;
  end process Ch1Gpio;

  Ch2Gpio: process(sDiagramSer2Gp3Oe, sDiagramCh2GpIn, sDiagramSer2Gp0Out, sDiagramSer2Gp1Out, sDiagramSer2Gp2Oe,
    sDiagramSer2Gp1Oe, sDiagramSer2Gp2Out, sDiagramSer2Gp3Out, sDiagramSer2Gp0Oe) is
  begin
    sDiagramCh2GpOut <= (others => '0');
    sDiagramCh2GpOe  <= (others => '0');
    sDiagramSer2Gp0In   <= sDiagramCh2GpIn(0);
    sDiagramCh2GpOut(0) <= sDiagramSer2Gp0Out;
    sDiagramCh2GpOe(0)  <= sDiagramSer2Gp0Oe;
    sDiagramSer2Gp1In   <= sDiagramCh2GpIn(1);
    sDiagramCh2GpOut(1) <= sDiagramSer2Gp1Out;
    sDiagramCh2GpOe(1)  <= sDiagramSer2Gp1Oe;
    sDiagramSer2Gp2In   <= sDiagramCh2GpIn(2);
    sDiagramCh2GpOut(2) <= sDiagramSer2Gp2Out;
    sDiagramCh2GpOe(2)  <= sDiagramSer2Gp2Oe;
    sDiagramSer2Gp3In   <= sDiagramCh2GpIn(3);
    sDiagramCh2GpOut(3) <= sDiagramSer2Gp3Out;
    sDiagramCh2GpOe(3)  <= sDiagramSer2Gp3Oe;
  end process Ch2Gpio;

  Ch3Gpio: process(sDiagramSer3Gp2Out, sDiagramCh3GpIn, sDiagramSer3Gp2Oe, sDiagramSer3Gp3Oe, sDiagramSer3Gp0Oe,
    sDiagramSer3Gp3Out, sDiagramSer3Gp1Out, sDiagramSer3Gp1Oe, sDiagramSer3Gp0Out) is
  begin
    sDiagramCh3GpOut <= (others => '0');
    sDiagramCh3GpOe  <= (others => '0');
    sDiagramSer3Gp0In   <= sDiagramCh3GpIn(0);
    sDiagramCh3GpOut(0) <= sDiagramSer3Gp0Out;
    sDiagramCh3GpOe(0)  <= sDiagramSer3Gp0Oe;
    sDiagramSer3Gp1In   <= sDiagramCh3GpIn(1);
    sDiagramCh3GpOut(1) <= sDiagramSer3Gp1Out;
    sDiagramCh3GpOe(1)  <= sDiagramSer3Gp1Oe;
    sDiagramSer3Gp2In   <= sDiagramCh3GpIn(2);
    sDiagramCh3GpOut(2) <= sDiagramSer3Gp2Out;
    sDiagramCh3GpOe(2)  <= sDiagramSer3Gp2Oe;
    sDiagramSer3Gp3In   <= sDiagramCh3GpIn(3);
    sDiagramCh3GpOut(3) <= sDiagramSer3Gp3Out;
    sDiagramCh3GpOe(3)  <= sDiagramSer3Gp3Oe;
  end process Ch3Gpio;

  Ch4Gpio: process(sDiagramCh4GpIn, sDiagramSer4Gp2Out, sDiagramSer4Gp2Oe, sDiagramSer4Gp1Out, sDiagramSer4Gp0Oe,
    sDiagramSer4Gp1Oe, sDiagramSer4Gp3Oe, sDiagramSer4Gp0Out, sDiagramSer4Gp3Out) is
  begin
    sDiagramCh4GpOut <= (others => '0');
    sDiagramCh4GpOe  <= (others => '0');
    sDiagramSer4Gp0In   <= sDiagramCh4GpIn(0);
    sDiagramCh4GpOut(0) <= sDiagramSer4Gp0Out;
    sDiagramCh4GpOe(0)  <= sDiagramSer4Gp0Oe;
    sDiagramSer4Gp1In   <= sDiagramCh4GpIn(1);
    sDiagramCh4GpOut(1) <= sDiagramSer4Gp1Out;
    sDiagramCh4GpOe(1)  <= sDiagramSer4Gp1Oe;
    sDiagramSer4Gp2In   <= sDiagramCh4GpIn(2);
    sDiagramCh4GpOut(2) <= sDiagramSer4Gp2Out;
    sDiagramCh4GpOe(2)  <= sDiagramSer4Gp2Oe;
    sDiagramSer4Gp3In   <= sDiagramCh4GpIn(3);
    sDiagramCh4GpOut(3) <= sDiagramSer4Gp3Out;
    sDiagramCh4GpOe(3)  <= sDiagramSer4Gp3Oe;   
  end process Ch4Gpio;

  Ch5Gpio: process(sDiagramSer5Gp1Oe, sDiagramSer5Gp3Out, sDiagramSer5Gp2Out, sDiagramSer5Gp2Oe, sDiagramSer5Gp3Oe,
    sDiagramCh5GpIn, sDiagramSer5Gp1Out, sDiagramSer5Gp0Oe, sDiagramSer5Gp0Out) is
  begin
    sDiagramCh5GpOut <= (others => '0');
    sDiagramCh5GpOe  <= (others => '0');
    sDiagramSer5Gp0In   <= sDiagramCh5GpIn(0);
    sDiagramCh5GpOut(0) <= sDiagramSer5Gp0Out;
    sDiagramCh5GpOe(0)  <= sDiagramSer5Gp0Oe;
    sDiagramSer5Gp1In   <= sDiagramCh5GpIn(1);
    sDiagramCh5GpOut(1) <= sDiagramSer5Gp1Out;
    sDiagramCh5GpOe(1)  <= sDiagramSer5Gp1Oe;
    sDiagramSer5Gp2In   <= sDiagramCh5GpIn(2);
    sDiagramCh5GpOut(2) <= sDiagramSer5Gp2Out;
    sDiagramCh5GpOe(2)  <= sDiagramSer5Gp2Oe;
    sDiagramSer5Gp3In   <= sDiagramCh5GpIn(3);
    sDiagramCh5GpOut(3) <= sDiagramSer5Gp3Out;
    sDiagramCh5GpOe(3)  <= sDiagramSer5Gp3Oe;
  end process Ch5Gpio;

  Ch6Gpio: process(sDiagramSer6Gp1Oe, sDiagramSer6Gp0Out, sDiagramSer6Gp0Oe, sDiagramSer6Gp3Out, sDiagramSer6Gp2Out,
    sDiagramCh6GpIn, sDiagramSer6Gp1Out, sDiagramSer6Gp3Oe, sDiagramSer6Gp2Oe) is
  begin
    sDiagramCh6GpOut <= (others => '0');
    sDiagramCh6GpOe  <= (others => '0');
    sDiagramSer6Gp0In   <= sDiagramCh6GpIn(0);
    sDiagramCh6GpOut(0) <= sDiagramSer6Gp0Out;
    sDiagramCh6GpOe(0)  <= sDiagramSer6Gp0Oe;
    sDiagramSer6Gp1In   <= sDiagramCh6GpIn(1);
    sDiagramCh6GpOut(1) <= sDiagramSer6Gp1Out;
    sDiagramCh6GpOe(1)  <= sDiagramSer6Gp1Oe;
    sDiagramSer6Gp2In   <= sDiagramCh6GpIn(2);
    sDiagramCh6GpOut(2) <= sDiagramSer6Gp2Out;
    sDiagramCh6GpOe(2)  <= sDiagramSer6Gp2Oe;
    sDiagramSer6Gp3In   <= sDiagramCh6GpIn(3);
    sDiagramCh6GpOut(3) <= sDiagramSer6Gp3Out;
    sDiagramCh6GpOe(3)  <= sDiagramSer6Gp3Oe;
  end process Ch6Gpio;

  Ch7Gpio: process(sDiagramCh7GpIn, sDiagramSer7Gp3Oe, sDiagramSer7Gp0Oe, sDiagramSer7Gp2Out, sDiagramSer7Gp3Out,
    sDiagramSer7Gp1Oe, sDiagramSer7Gp0Out, sDiagramSer7Gp1Out, sDiagramSer7Gp2Oe) is
  begin
    sDiagramCh7GpOut <= (others => '0');
    sDiagramCh7GpOe  <= (others => '0');
    sDiagramSer7Gp0In   <= sDiagramCh7GpIn(0);
    sDiagramCh7GpOut(0) <= sDiagramSer7Gp0Out;
    sDiagramCh7GpOe(0)  <= sDiagramSer7Gp0Oe;
    sDiagramSer7Gp1In   <= sDiagramCh7GpIn(1);
    sDiagramCh7GpOut(1) <= sDiagramSer7Gp1Out;
    sDiagramCh7GpOe(1)  <= sDiagramSer7Gp1Oe;
    sDiagramSer7Gp2In   <= sDiagramCh7GpIn(2);
    sDiagramCh7GpOut(2) <= sDiagramSer7Gp2Out;
    sDiagramCh7GpOe(2)  <= sDiagramSer7Gp2Oe;
    sDiagramSer7Gp3In   <= sDiagramCh7GpIn(3);
    sDiagramCh7GpOut(3) <= sDiagramSer7Gp3Out;
    sDiagramCh7GpOe(3)  <= sDiagramSer7Gp3Oe;
  end process Ch7Gpio;

  --vhook_nowarn sDiagramMiscGpIn
  sDiagramMiscGpOut <= (others => '0');
  sDiagramMiscGpOe  <= (others => '0');
end rtl;
