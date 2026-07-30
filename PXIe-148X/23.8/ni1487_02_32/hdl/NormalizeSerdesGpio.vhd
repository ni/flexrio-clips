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


    -- Indiviual Serdes GPIO
    sDiagramSer0Mfp0In  : out std_logic;
    sDiagramSer0Mfp0Out : in  std_logic;
    sDiagramSer0Mfp0Oe  : in  std_logic;
    sDiagramSer0Mfp1In  : out std_logic;
    sDiagramSer0Mfp2In  : out std_logic;
    sDiagramSer0Mfp3In  : out std_logic;
    sDiagramSer0Mfp3Out : in  std_logic;
    sDiagramSer0Mfp3Oe  : in  std_logic;
    sDiagramSer0Mfp4In  : out std_logic;
    sDiagramSer0Mfp4Out : in  std_logic;
    sDiagramSer0Mfp4Oe  : in  std_logic;
    sDiagramSer0Mfp6In  : out std_logic;
    sDiagramSer0Mfp6Out : in  std_logic;
    sDiagramSer0Mfp6Oe  : in  std_logic;
    sDiagramSer0Mfp7In  : out std_logic;
    sDiagramSer0Mfp7Out : in  std_logic;
    sDiagramSer0Mfp7Oe  : in  std_logic;
    sDiagramSer0Mfp8In  : out std_logic;
    sDiagramSer0Mfp8Out : in  std_logic;
    sDiagramSer0Mfp8Oe  : in  std_logic;
    sDiagramSer1Mfp0In  : out std_logic;
    sDiagramSer1Mfp0Out : in  std_logic;
    sDiagramSer1Mfp0Oe  : in  std_logic;
    sDiagramSer1Mfp1In  : out std_logic;
    sDiagramSer1Mfp2In  : out std_logic;
    sDiagramSer1Mfp3In  : out std_logic;
    sDiagramSer1Mfp3Out : in  std_logic;
    sDiagramSer1Mfp3Oe  : in  std_logic;
    sDiagramSer1Mfp4In  : out std_logic;
    sDiagramSer1Mfp4Out : in  std_logic;
    sDiagramSer1Mfp4Oe  : in  std_logic;
    sDiagramSer1Mfp6In  : out std_logic;
    sDiagramSer1Mfp6Out : in  std_logic;
    sDiagramSer1Mfp6Oe  : in  std_logic;
    sDiagramSer1Mfp7In  : out std_logic;
    sDiagramSer1Mfp7Out : in  std_logic;
    sDiagramSer1Mfp7Oe  : in  std_logic;
    sDiagramSer1Mfp8In  : out std_logic;
    sDiagramSer1Mfp8Out : in  std_logic;
    sDiagramSer1Mfp8Oe  : in  std_logic;
    sDiagramSer2Mfp0In  : out std_logic;
    sDiagramSer2Mfp0Out : in  std_logic;
    sDiagramSer2Mfp0Oe  : in  std_logic;
    sDiagramSer2Mfp1In  : out std_logic;
    sDiagramSer2Mfp2In  : out std_logic;
    sDiagramSer2Mfp3In  : out std_logic;
    sDiagramSer2Mfp3Out : in  std_logic;
    sDiagramSer2Mfp3Oe  : in  std_logic;
    sDiagramSer2Mfp4In  : out std_logic;
    sDiagramSer2Mfp4Out : in  std_logic;
    sDiagramSer2Mfp4Oe  : in  std_logic;
    sDiagramSer2Mfp6In  : out std_logic;
    sDiagramSer2Mfp6Out : in  std_logic;
    sDiagramSer2Mfp6Oe  : in  std_logic;
    sDiagramSer2Mfp7In  : out std_logic;
    sDiagramSer2Mfp7Out : in  std_logic;
    sDiagramSer2Mfp7Oe  : in  std_logic;
    sDiagramSer2Mfp8In  : out std_logic;
    sDiagramSer2Mfp8Out : in  std_logic;
    sDiagramSer2Mfp8Oe  : in  std_logic;
    sDiagramSer3Mfp0In  : out std_logic;
    sDiagramSer3Mfp0Out : in  std_logic;
    sDiagramSer3Mfp0Oe  : in  std_logic;
    sDiagramSer3Mfp1In  : out std_logic;
    sDiagramSer3Mfp2In  : out std_logic;
    sDiagramSer3Mfp3In  : out std_logic;
    sDiagramSer3Mfp3Out : in  std_logic;
    sDiagramSer3Mfp3Oe  : in  std_logic;
    sDiagramSer3Mfp4In  : out std_logic;
    sDiagramSer3Mfp4Out : in  std_logic;
    sDiagramSer3Mfp4Oe  : in  std_logic;
    sDiagramSer3Mfp6In  : out std_logic;
    sDiagramSer3Mfp6Out : in  std_logic;
    sDiagramSer3Mfp6Oe  : in  std_logic;
    sDiagramSer3Mfp7In  : out std_logic;
    sDiagramSer3Mfp7Out : in  std_logic;
    sDiagramSer3Mfp7Oe  : in  std_logic;
    sDiagramSer3Mfp8In  : out std_logic;
    sDiagramSer3Mfp8Out : in  std_logic;
    sDiagramSer3Mfp8Oe  : in  std_logic;
    sDiagramSer4Mfp0In  : out std_logic;
    sDiagramSer4Mfp0Out : in  std_logic;
    sDiagramSer4Mfp0Oe  : in  std_logic;
    sDiagramSer4Mfp1In  : out std_logic;
    sDiagramSer4Mfp2In  : out std_logic;
    sDiagramSer4Mfp3In  : out std_logic;
    sDiagramSer4Mfp3Out : in  std_logic;
    sDiagramSer4Mfp3Oe  : in  std_logic;
    sDiagramSer4Mfp4In  : out std_logic;
    sDiagramSer4Mfp4Out : in  std_logic;
    sDiagramSer4Mfp4Oe  : in  std_logic;
    sDiagramSer4Mfp6In  : out std_logic;
    sDiagramSer4Mfp6Out : in  std_logic;
    sDiagramSer4Mfp6Oe  : in  std_logic;
    sDiagramSer4Mfp7In  : out std_logic;
    sDiagramSer4Mfp7Out : in  std_logic;
    sDiagramSer4Mfp7Oe  : in  std_logic;
    sDiagramSer4Mfp8In  : out std_logic;
    sDiagramSer4Mfp8Out : in  std_logic;
    sDiagramSer4Mfp8Oe  : in  std_logic;
    sDiagramSer5Mfp0In  : out std_logic;
    sDiagramSer5Mfp0Out : in  std_logic;
    sDiagramSer5Mfp0Oe  : in  std_logic;
    sDiagramSer5Mfp1In  : out std_logic;
    sDiagramSer5Mfp2In  : out std_logic;
    sDiagramSer5Mfp3In  : out std_logic;
    sDiagramSer5Mfp3Out : in  std_logic;
    sDiagramSer5Mfp3Oe  : in  std_logic;
    sDiagramSer5Mfp4In  : out std_logic;
    sDiagramSer5Mfp4Out : in  std_logic;
    sDiagramSer5Mfp4Oe  : in  std_logic;
    sDiagramSer5Mfp6In  : out std_logic;
    sDiagramSer5Mfp6Out : in  std_logic;
    sDiagramSer5Mfp6Oe  : in  std_logic;
    sDiagramSer5Mfp7In  : out std_logic;
    sDiagramSer5Mfp7Out : in  std_logic;
    sDiagramSer5Mfp7Oe  : in  std_logic;
    sDiagramSer5Mfp8In  : out std_logic;
    sDiagramSer5Mfp8Out : in  std_logic;
    sDiagramSer5Mfp8Oe  : in  std_logic;
    sDiagramSer6Mfp0In  : out std_logic;
    sDiagramSer6Mfp0Out : in  std_logic;
    sDiagramSer6Mfp0Oe  : in  std_logic;
    sDiagramSer6Mfp1In  : out std_logic;
    sDiagramSer6Mfp2In  : out std_logic;
    sDiagramSer6Mfp3In  : out std_logic;
    sDiagramSer6Mfp3Out : in  std_logic;
    sDiagramSer6Mfp3Oe  : in  std_logic;
    sDiagramSer6Mfp4In  : out std_logic;
    sDiagramSer6Mfp4Out : in  std_logic;
    sDiagramSer6Mfp4Oe  : in  std_logic;
    sDiagramSer6Mfp6In  : out std_logic;
    sDiagramSer6Mfp6Out : in  std_logic;
    sDiagramSer6Mfp6Oe  : in  std_logic;
    sDiagramSer6Mfp7In  : out std_logic;
    sDiagramSer6Mfp7Out : in  std_logic;
    sDiagramSer6Mfp7Oe  : in  std_logic;
    sDiagramSer6Mfp8In  : out std_logic;
    sDiagramSer6Mfp8Out : in  std_logic;
    sDiagramSer6Mfp8Oe  : in  std_logic;
    sDiagramSer7Mfp0In  : out std_logic;
    sDiagramSer7Mfp0Out : in  std_logic;
    sDiagramSer7Mfp0Oe  : in  std_logic;
    sDiagramSer7Mfp1In  : out std_logic;
    sDiagramSer7Mfp2In  : out std_logic;
    sDiagramSer7Mfp3In  : out std_logic;
    sDiagramSer7Mfp3Out : in  std_logic;
    sDiagramSer7Mfp3Oe  : in  std_logic;
    sDiagramSer7Mfp4In  : out std_logic;
    sDiagramSer7Mfp4Out : in  std_logic;
    sDiagramSer7Mfp4Oe  : in  std_logic;
    sDiagramSer7Mfp6In  : out std_logic;
    sDiagramSer7Mfp6Out : in  std_logic;
    sDiagramSer7Mfp6Oe  : in  std_logic;
    sDiagramSer7Mfp7In  : out std_logic;
    sDiagramSer7Mfp7Out : in  std_logic;
    sDiagramSer7Mfp7Oe  : in  std_logic;
    sDiagramSer7Mfp8In  : out std_logic;
    sDiagramSer7Mfp8Out : in  std_logic;
    sDiagramSer7Mfp8Oe  : in  std_logic
  );
end NormalizeSerdesGpio;

architecture rtl of NormalizeSerdesGpio is

begin
  Ch0Gpio: process(sDiagramSer0Mfp7Oe, sDiagramSer0Mfp7Out, sDiagramSer0Mfp8Oe, sDiagramSer0Mfp3Oe, sDiagramSer0Mfp3Out,
    sDiagramSer0Mfp0Oe, sDiagramSer0Mfp0Out, sDiagramSer0Mfp6Out, sDiagramSer0Mfp4Oe, sDiagramSer0Mfp4Out,
    sDiagramSer0Mfp6Oe, sDiagramSer0Mfp8Out, sDiagramCh0GpIn) is
  begin
    sDiagramCh0GpOut <= (others => '0');
    sDiagramCh0GpOe  <= (others => '0');
    sDiagramSer0Mfp0In   <= sDiagramCh0GpIn(0);
    sDiagramCh0GpOut(0) <= sDiagramSer0Mfp0Out;
    sDiagramCh0GpOe(0)  <= sDiagramSer0Mfp0Oe;
    sDiagramSer0Mfp1In   <= sDiagramCh0GpIn(2);
    sDiagramSer0Mfp2In   <= sDiagramCh0GpIn(3);
    sDiagramSer0Mfp3In   <= sDiagramCh0GpIn(1);
    sDiagramCh0GpOut(1) <= sDiagramSer0Mfp3Out;
    sDiagramCh0GpOe(1)  <= sDiagramSer0Mfp3Oe;
    sDiagramSer0Mfp4In   <= sDiagramCh0GpIn(4);
    sDiagramCh0GpOut(4) <= sDiagramSer0Mfp4Out;
    sDiagramCh0GpOe(4)  <= sDiagramSer0Mfp4Oe;
    sDiagramSer0Mfp6In   <= sDiagramCh0GpIn(5);
    sDiagramCh0GpOut(5) <= sDiagramSer0Mfp6Out;
    sDiagramCh0GpOe(5)  <= sDiagramSer0Mfp6Oe;
    sDiagramSer0Mfp7In   <= sDiagramCh0GpIn(6);
    sDiagramCh0GpOut(6) <= sDiagramSer0Mfp7Out;
    sDiagramCh0GpOe(6)  <= sDiagramSer0Mfp7Oe;
    sDiagramSer0Mfp8In   <= sDiagramCh0GpIn(7);
    sDiagramCh0GpOut(7) <= sDiagramSer0Mfp8Out;
    sDiagramCh0GpOe(7)  <= sDiagramSer0Mfp8Oe;
  end process Ch0Gpio;

  Ch1Gpio: process(sDiagramSer1Mfp8Out, sDiagramSer1Mfp7Oe, sDiagramSer1Mfp6Oe, sDiagramSer1Mfp6Out, sDiagramSer1Mfp4Out,
    sDiagramSer1Mfp8Oe, sDiagramSer1Mfp7Out, sDiagramSer1Mfp0Out, sDiagramSer1Mfp3Out, sDiagramSer1Mfp3Oe,
    sDiagramSer1Mfp4Oe, sDiagramCh1GpIn, sDiagramSer1Mfp0Oe) is
  begin
    sDiagramCh1GpOut <= (others => '0');
    sDiagramCh1GpOe  <= (others => '0');
    sDiagramSer1Mfp0In   <= sDiagramCh1GpIn(0);
    sDiagramCh1GpOut(0) <= sDiagramSer1Mfp0Out;
    sDiagramCh1GpOe(0)  <= sDiagramSer1Mfp0Oe;
    sDiagramSer1Mfp1In   <= sDiagramCh1GpIn(2);
    sDiagramSer1Mfp2In   <= sDiagramCh1GpIn(3);
    sDiagramSer1Mfp3In   <= sDiagramCh1GpIn(1);
    sDiagramCh1GpOut(1) <= sDiagramSer1Mfp3Out;
    sDiagramCh1GpOe(1)  <= sDiagramSer1Mfp3Oe;
    sDiagramSer1Mfp4In   <= sDiagramCh1GpIn(4);
    sDiagramCh1GpOut(4) <= sDiagramSer1Mfp4Out;
    sDiagramCh1GpOe(4)  <= sDiagramSer1Mfp4Oe;
    sDiagramSer1Mfp6In   <= sDiagramCh1GpIn(5);
    sDiagramCh1GpOut(5) <= sDiagramSer1Mfp6Out;
    sDiagramCh1GpOe(5)  <= sDiagramSer1Mfp6Oe;
    sDiagramSer1Mfp7In   <= sDiagramCh1GpIn(6);
    sDiagramCh1GpOut(6) <= sDiagramSer1Mfp7Out;
    sDiagramCh1GpOe(6)  <= sDiagramSer1Mfp7Oe;
    sDiagramSer1Mfp8In   <= sDiagramCh1GpIn(7);
    sDiagramCh1GpOut(7) <= sDiagramSer1Mfp8Out;
    sDiagramCh1GpOe(7)  <= sDiagramSer1Mfp8Oe;
  end process Ch1Gpio;

  Ch2Gpio: process(sDiagramSer2Mfp8Oe, sDiagramSer2Mfp4Out, sDiagramSer2Mfp3Out, sDiagramSer2Mfp6Out, sDiagramSer2Mfp0Out,
    sDiagramSer2Mfp8Out, sDiagramSer2Mfp0Oe, sDiagramSer2Mfp7Oe, sDiagramSer2Mfp3Oe, sDiagramSer2Mfp6Oe, sDiagramSer2Mfp4Oe,
    sDiagramCh2GpIn, sDiagramSer2Mfp7Out) is
  begin
    sDiagramCh2GpOut <= (others => '0');
    sDiagramCh2GpOe  <= (others => '0');
    sDiagramSer2Mfp0In   <= sDiagramCh2GpIn(0);
    sDiagramCh2GpOut(0) <= sDiagramSer2Mfp0Out;
    sDiagramCh2GpOe(0)  <= sDiagramSer2Mfp0Oe;
    sDiagramSer2Mfp1In   <= sDiagramCh2GpIn(2);
    sDiagramSer2Mfp2In   <= sDiagramCh2GpIn(3);
    sDiagramSer2Mfp3In   <= sDiagramCh2GpIn(1);
    sDiagramCh2GpOut(1) <= sDiagramSer2Mfp3Out;
    sDiagramCh2GpOe(1)  <= sDiagramSer2Mfp3Oe;
    sDiagramSer2Mfp4In   <= sDiagramCh2GpIn(4);
    sDiagramCh2GpOut(4) <= sDiagramSer2Mfp4Out;
    sDiagramCh2GpOe(4)  <= sDiagramSer2Mfp4Oe;
    sDiagramSer2Mfp6In   <= sDiagramCh2GpIn(5);
    sDiagramCh2GpOut(5) <= sDiagramSer2Mfp6Out;
    sDiagramCh2GpOe(5)  <= sDiagramSer2Mfp6Oe;
    sDiagramSer2Mfp7In   <= sDiagramCh2GpIn(6);
    sDiagramCh2GpOut(6) <= sDiagramSer2Mfp7Out;
    sDiagramCh2GpOe(6)  <= sDiagramSer2Mfp7Oe;
    sDiagramSer2Mfp8In   <= sDiagramCh2GpIn(7);
    sDiagramCh2GpOut(7) <= sDiagramSer2Mfp8Out;
    sDiagramCh2GpOe(7)  <= sDiagramSer2Mfp8Oe;
  end process Ch2Gpio;

  Ch3Gpio: process(sDiagramSer3Mfp3Oe, sDiagramSer3Mfp3Out, sDiagramSer3Mfp8Out, sDiagramSer3Mfp7Oe, sDiagramSer3Mfp7Out,
    sDiagramSer3Mfp6Oe, sDiagramSer3Mfp4Oe, sDiagramSer3Mfp4Out, sDiagramSer3Mfp6Out, sDiagramSer3Mfp8Oe, sDiagramCh3GpIn,
    sDiagramSer3Mfp0Oe, sDiagramSer3Mfp0Out) is
  begin
    sDiagramCh3GpOut <= (others => '0');
    sDiagramCh3GpOe  <= (others => '0');
    sDiagramSer3Mfp0In   <= sDiagramCh3GpIn(0);
    sDiagramCh3GpOut(0) <= sDiagramSer3Mfp0Out;
    sDiagramCh3GpOe(0)  <= sDiagramSer3Mfp0Oe;
    sDiagramSer3Mfp1In   <= sDiagramCh3GpIn(2);
    sDiagramSer3Mfp2In   <= sDiagramCh3GpIn(3);
    sDiagramSer3Mfp3In   <= sDiagramCh3GpIn(1);
    sDiagramCh3GpOut(1) <= sDiagramSer3Mfp3Out;
    sDiagramCh3GpOe(1)  <= sDiagramSer3Mfp3Oe;
    sDiagramSer3Mfp4In   <= sDiagramCh3GpIn(4);
    sDiagramCh3GpOut(4) <= sDiagramSer3Mfp4Out;
    sDiagramCh3GpOe(4)  <= sDiagramSer3Mfp4Oe;
    sDiagramSer3Mfp6In   <= sDiagramCh3GpIn(5);
    sDiagramCh3GpOut(5) <= sDiagramSer3Mfp6Out;
    sDiagramCh3GpOe(5)  <= sDiagramSer3Mfp6Oe;
    sDiagramSer3Mfp7In   <= sDiagramCh3GpIn(6);
    sDiagramCh3GpOut(6) <= sDiagramSer3Mfp7Out;
    sDiagramCh3GpOe(6)  <= sDiagramSer3Mfp7Oe;
    sDiagramSer3Mfp8In   <= sDiagramCh3GpIn(7);
    sDiagramCh3GpOut(7) <= sDiagramSer3Mfp8Out;
    sDiagramCh3GpOe(7)  <= sDiagramSer3Mfp8Oe;
  end process Ch3Gpio;

  Ch4Gpio: process(sDiagramSer4Mfp3Oe, sDiagramSer4Mfp3Out, sDiagramSer4Mfp6Oe, sDiagramSer4Mfp7Oe, sDiagramSer4Mfp7Out,
    sDiagramSer4Mfp8Oe, sDiagramSer4Mfp6Out, sDiagramSer4Mfp4Oe, sDiagramSer4Mfp4Out, sDiagramSer4Mfp0Oe,
    sDiagramSer4Mfp0Out, sDiagramCh4GpIn, sDiagramSer4Mfp8Out) is
  begin
    sDiagramCh4GpOut <= (others => '0');
    sDiagramCh4GpOe  <= (others => '0');
    sDiagramSer4Mfp0In   <= sDiagramCh4GpIn(0);
    sDiagramCh4GpOut(0) <= sDiagramSer4Mfp0Out;
    sDiagramCh4GpOe(0)  <= sDiagramSer4Mfp0Oe;
    sDiagramSer4Mfp1In   <= sDiagramCh4GpIn(2);
    sDiagramSer4Mfp2In   <= sDiagramCh4GpIn(3);
    sDiagramSer4Mfp3In   <= sDiagramCh4GpIn(1);
    sDiagramCh4GpOut(1) <= sDiagramSer4Mfp3Out;
    sDiagramCh4GpOe(1)  <= sDiagramSer4Mfp3Oe;
    sDiagramSer4Mfp4In   <= sDiagramCh4GpIn(4);
    sDiagramCh4GpOut(4) <= sDiagramSer4Mfp4Out;
    sDiagramCh4GpOe(4)  <= sDiagramSer4Mfp4Oe;
    sDiagramSer4Mfp6In   <= sDiagramCh4GpIn(5);
    sDiagramCh4GpOut(5) <= sDiagramSer4Mfp6Out;
    sDiagramCh4GpOe(5)  <= sDiagramSer4Mfp6Oe;
    sDiagramSer4Mfp7In   <= sDiagramCh4GpIn(6);
    sDiagramCh4GpOut(6) <= sDiagramSer4Mfp7Out;
    sDiagramCh4GpOe(6)  <= sDiagramSer4Mfp7Oe;
    sDiagramSer4Mfp8In   <= sDiagramCh4GpIn(7);
    sDiagramCh4GpOut(7) <= sDiagramSer4Mfp8Out;
    sDiagramCh4GpOe(7)  <= sDiagramSer4Mfp8Oe;
  end process Ch4Gpio;

  Ch5Gpio: process(sDiagramSer5Mfp7Oe, sDiagramSer5Mfp0Oe, sDiagramSer5Mfp4Oe, sDiagramSer5Mfp0Out, sDiagramSer5Mfp6Oe,
    sDiagramSer5Mfp3Out, sDiagramSer5Mfp4Out, sDiagramSer5Mfp3Oe, sDiagramSer5Mfp7Out, sDiagramCh5GpIn, sDiagramSer5Mfp6Out,
    sDiagramSer5Mfp8Oe, sDiagramSer5Mfp8Out) is
  begin
    sDiagramCh5GpOut <= (others => '0');
    sDiagramCh5GpOe  <= (others => '0');
    sDiagramSer5Mfp0In   <= sDiagramCh5GpIn(0);
    sDiagramCh5GpOut(0) <= sDiagramSer5Mfp0Out;
    sDiagramCh5GpOe(0)  <= sDiagramSer5Mfp0Oe;
    sDiagramSer5Mfp1In   <= sDiagramCh5GpIn(2);
    sDiagramSer5Mfp2In   <= sDiagramCh5GpIn(3);
    sDiagramSer5Mfp3In   <= sDiagramCh5GpIn(1);
    sDiagramCh5GpOut(1) <= sDiagramSer5Mfp3Out;
    sDiagramCh5GpOe(1)  <= sDiagramSer5Mfp3Oe;
    sDiagramSer5Mfp4In   <= sDiagramCh5GpIn(4);
    sDiagramCh5GpOut(4) <= sDiagramSer5Mfp4Out;
    sDiagramCh5GpOe(4)  <= sDiagramSer5Mfp4Oe;
    sDiagramSer5Mfp6In   <= sDiagramCh5GpIn(5);
    sDiagramCh5GpOut(5) <= sDiagramSer5Mfp6Out;
    sDiagramCh5GpOe(5)  <= sDiagramSer5Mfp6Oe;
    sDiagramSer5Mfp7In   <= sDiagramCh5GpIn(6);
    sDiagramCh5GpOut(6) <= sDiagramSer5Mfp7Out;
    sDiagramCh5GpOe(6)  <= sDiagramSer5Mfp7Oe;
    sDiagramSer5Mfp8In   <= sDiagramCh5GpIn(7);
    sDiagramCh5GpOut(7) <= sDiagramSer5Mfp8Out;
    sDiagramCh5GpOe(7)  <= sDiagramSer5Mfp8Oe;
  end process Ch5Gpio;

  Ch6Gpio: process(sDiagramSer6Mfp6Out, sDiagramSer6Mfp8Oe, sDiagramSer6Mfp8Out, sDiagramSer6Mfp6Oe, sDiagramSer6Mfp4Oe,
    sDiagramSer6Mfp3Oe, sDiagramSer6Mfp7Oe, sDiagramSer6Mfp3Out, sDiagramCh6GpIn, sDiagramSer6Mfp0Out, sDiagramSer6Mfp7Out,
    sDiagramSer6Mfp0Oe, sDiagramSer6Mfp4Out) is
  begin
    sDiagramCh6GpOut <= (others => '0');
    sDiagramCh6GpOe  <= (others => '0');
    sDiagramSer6Mfp0In   <= sDiagramCh6GpIn(0);
    sDiagramCh6GpOut(0) <= sDiagramSer6Mfp0Out;
    sDiagramCh6GpOe(0)  <= sDiagramSer6Mfp0Oe;
    sDiagramSer6Mfp1In   <= sDiagramCh6GpIn(2);
    sDiagramSer6Mfp2In   <= sDiagramCh6GpIn(3);
    sDiagramSer6Mfp3In   <= sDiagramCh6GpIn(1);
    sDiagramCh6GpOut(1) <= sDiagramSer6Mfp3Out;
    sDiagramCh6GpOe(1)  <= sDiagramSer6Mfp3Oe;
    sDiagramSer6Mfp4In   <= sDiagramCh6GpIn(4);
    sDiagramCh6GpOut(4) <= sDiagramSer6Mfp4Out;
    sDiagramCh6GpOe(4)  <= sDiagramSer6Mfp4Oe;
    sDiagramSer6Mfp6In   <= sDiagramCh6GpIn(5);
    sDiagramCh6GpOut(5) <= sDiagramSer6Mfp6Out;
    sDiagramCh6GpOe(5)  <= sDiagramSer6Mfp6Oe;
    sDiagramSer6Mfp7In   <= sDiagramCh6GpIn(6);
    sDiagramCh6GpOut(6) <= sDiagramSer6Mfp7Out;
    sDiagramCh6GpOe(6)  <= sDiagramSer6Mfp7Oe;
    sDiagramSer6Mfp8In   <= sDiagramCh6GpIn(7);
    sDiagramCh6GpOut(7) <= sDiagramSer6Mfp8Out;
    sDiagramCh6GpOe(7)  <= sDiagramSer6Mfp8Oe;
  end process Ch6Gpio;

  Ch7Gpio: process(sDiagramSer7Mfp7Oe, sDiagramSer7Mfp7Out, sDiagramSer7Mfp8Oe, sDiagramSer7Mfp3Oe, sDiagramSer7Mfp3Out,
    sDiagramSer7Mfp6Oe, sDiagramSer7Mfp0Oe, sDiagramSer7Mfp0Out, sDiagramCh7GpIn, sDiagramSer7Mfp8Out, sDiagramSer7Mfp4Oe,
    sDiagramSer7Mfp4Out, sDiagramSer7Mfp6Out) is
  begin
    sDiagramCh7GpOut <= (others => '0');
    sDiagramCh7GpOe  <= (others => '0');
    sDiagramSer7Mfp0In   <= sDiagramCh7GpIn(0);
    sDiagramCh7GpOut(0) <= sDiagramSer7Mfp0Out;
    sDiagramCh7GpOe(0)  <= sDiagramSer7Mfp0Oe;
    sDiagramSer7Mfp1In   <= sDiagramCh7GpIn(2);
    sDiagramSer7Mfp2In   <= sDiagramCh7GpIn(3);
    sDiagramSer7Mfp3In   <= sDiagramCh7GpIn(1);
    sDiagramCh7GpOut(1) <= sDiagramSer7Mfp3Out;
    sDiagramCh7GpOe(1)  <= sDiagramSer7Mfp3Oe;
    sDiagramSer7Mfp4In   <= sDiagramCh7GpIn(4);
    sDiagramCh7GpOut(4) <= sDiagramSer7Mfp4Out;
    sDiagramCh7GpOe(4)  <= sDiagramSer7Mfp4Oe;
    sDiagramSer7Mfp6In   <= sDiagramCh7GpIn(5);
    sDiagramCh7GpOut(5) <= sDiagramSer7Mfp6Out;
    sDiagramCh7GpOe(5)  <= sDiagramSer7Mfp6Oe;
    sDiagramSer7Mfp7In   <= sDiagramCh7GpIn(6);
    sDiagramCh7GpOut(6) <= sDiagramSer7Mfp7Out;
    sDiagramCh7GpOe(6)  <= sDiagramSer7Mfp7Oe;
    sDiagramSer7Mfp8In   <= sDiagramCh7GpIn(7);
    sDiagramCh7GpOut(7) <= sDiagramSer7Mfp8Out;
    sDiagramCh7GpOe(7)  <= sDiagramSer7Mfp8Oe;
  end process Ch7Gpio;

  --vhook_nowarn sDiagramMiscGpIn
  sDiagramMiscGpOut <= (others => '0');
  sDiagramMiscGpOe  <= (others => '0');
end rtl;
