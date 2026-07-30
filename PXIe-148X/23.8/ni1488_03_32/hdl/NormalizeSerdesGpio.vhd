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
    sDiagramDes0Gp0In  : out std_logic;
    sDiagramDes0Gp0Out : in  std_logic;
    sDiagramDes0Gp0Oe  : in  std_logic;
    sDiagramDes0Gp1In  : out std_logic;
    sDiagramDes0Gp1Out : in  std_logic;
    sDiagramDes0Gp1Oe  : in  std_logic;
    sDiagramDes0Gp2In  : out std_logic;
    sDiagramDes0Gp2Out : in  std_logic;
    sDiagramDes0Gp2Oe  : in  std_logic;
    sDiagramDes0Gp3In  : out std_logic;
    sDiagramDes0Gp3Out : in  std_logic;
    sDiagramDes0Gp3Oe  : in  std_logic;
    sDiagramDes0Gp4In  : out std_logic;
    sDiagramDes0Gp4Out : in  std_logic;
    sDiagramDes0Gp4Oe  : in  std_logic;
    sDiagramDes0Gp5In  : out std_logic;
    sDiagramDes0Gp5Out : in  std_logic;
    sDiagramDes0Gp5Oe  : in  std_logic;
    sDiagramDes0Gp6In  : out std_logic;
    sDiagramDes0Gp6Out : in  std_logic;
    sDiagramDes0Gp6Oe  : in  std_logic;
    sDiagramDes0Gp7In  : out std_logic;
    sDiagramDes0Gp7Out : in  std_logic;
    sDiagramDes0Gp7Oe  : in  std_logic;
    sDiagramDes1Gp0In  : out std_logic;
    sDiagramDes1Gp0Out : in  std_logic;
    sDiagramDes1Gp0Oe  : in  std_logic;
    sDiagramDes1Gp1In  : out std_logic;
    sDiagramDes1Gp1Out : in  std_logic;
    sDiagramDes1Gp1Oe  : in  std_logic;
    sDiagramDes1Gp2In  : out std_logic;
    sDiagramDes1Gp2Out : in  std_logic;
    sDiagramDes1Gp2Oe  : in  std_logic;
    sDiagramDes1Gp3In  : out std_logic;
    sDiagramDes1Gp3Out : in  std_logic;
    sDiagramDes1Gp3Oe  : in  std_logic;
    sDiagramDes1Gp4In  : out std_logic;
    sDiagramDes1Gp4Out : in  std_logic;
    sDiagramDes1Gp4Oe  : in  std_logic;
    sDiagramDes1Gp5In  : out std_logic;
    sDiagramDes1Gp5Out : in  std_logic;
    sDiagramDes1Gp5Oe  : in  std_logic;
    sDiagramDes1Gp6In  : out std_logic;
    sDiagramDes1Gp6Out : in  std_logic;
    sDiagramDes1Gp6Oe  : in  std_logic;
    sDiagramDes1Gp7In  : out std_logic;
    sDiagramDes1Gp7Out : in  std_logic;
    sDiagramDes1Gp7Oe  : in  std_logic;
    sDiagramDes2Gp0In  : out std_logic;
    sDiagramDes2Gp0Out : in  std_logic;
    sDiagramDes2Gp0Oe  : in  std_logic;
    sDiagramDes2Gp1In  : out std_logic;
    sDiagramDes2Gp1Out : in  std_logic;
    sDiagramDes2Gp1Oe  : in  std_logic;
    sDiagramDes2Gp2In  : out std_logic;
    sDiagramDes2Gp2Out : in  std_logic;
    sDiagramDes2Gp2Oe  : in  std_logic;
    sDiagramDes2Gp3In  : out std_logic;
    sDiagramDes2Gp3Out : in  std_logic;
    sDiagramDes2Gp3Oe  : in  std_logic;
    sDiagramDes2Gp4In  : out std_logic;
    sDiagramDes2Gp4Out : in  std_logic;
    sDiagramDes2Gp4Oe  : in  std_logic;
    sDiagramDes2Gp5In  : out std_logic;
    sDiagramDes2Gp5Out : in  std_logic;
    sDiagramDes2Gp5Oe  : in  std_logic;
    sDiagramDes2Gp6In  : out std_logic;
    sDiagramDes2Gp6Out : in  std_logic;
    sDiagramDes2Gp6Oe  : in  std_logic;
    sDiagramDes2Gp7In  : out std_logic;
    sDiagramDes2Gp7Out : in  std_logic;
    sDiagramDes2Gp7Oe  : in  std_logic;
    sDiagramDes3Gp0In  : out std_logic;
    sDiagramDes3Gp0Out : in  std_logic;
    sDiagramDes3Gp0Oe  : in  std_logic;
    sDiagramDes3Gp1In  : out std_logic;
    sDiagramDes3Gp1Out : in  std_logic;
    sDiagramDes3Gp1Oe  : in  std_logic;
    sDiagramDes3Gp2In  : out std_logic;
    sDiagramDes3Gp2Out : in  std_logic;
    sDiagramDes3Gp2Oe  : in  std_logic;
    sDiagramDes3Gp3In  : out std_logic;
    sDiagramDes3Gp3Out : in  std_logic;
    sDiagramDes3Gp3Oe  : in  std_logic;
    sDiagramDes3Gp4In  : out std_logic;
    sDiagramDes3Gp4Out : in  std_logic;
    sDiagramDes3Gp4Oe  : in  std_logic;
    sDiagramDes3Gp5In  : out std_logic;
    sDiagramDes3Gp5Out : in  std_logic;
    sDiagramDes3Gp5Oe  : in  std_logic;
    sDiagramDes3Gp6In  : out std_logic;
    sDiagramDes3Gp6Out : in  std_logic;
    sDiagramDes3Gp6Oe  : in  std_logic;
    sDiagramDes3Gp7In  : out std_logic;
    sDiagramDes3Gp7Out : in  std_logic;
    sDiagramDes3Gp7Oe  : in  std_logic;
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

    sDiagramDes0Gp9In  : out std_logic;
    sDiagramDes0Gp9Out : in  std_logic;
    sDiagramDes0Gp9Oe  : in  std_logic;
    sDiagramDes0Gp10In  : out std_logic;
    sDiagramDes0Gp10Out : in  std_logic;
    sDiagramDes0Gp10Oe  : in  std_logic;
    sDiagramDes1Gp9In  : out std_logic;
    sDiagramDes1Gp9Out : in  std_logic;
    sDiagramDes1Gp9Oe  : in  std_logic;
    sDiagramDes1Gp10In  : out std_logic;
    sDiagramDes1Gp10Out : in  std_logic;
    sDiagramDes1Gp10Oe  : in  std_logic;
    sDiagramDes2Gp9In  : out std_logic;
    sDiagramDes2Gp9Out : in  std_logic;
    sDiagramDes2Gp9Oe  : in  std_logic;
    sDiagramDes2Gp10In  : out std_logic;
    sDiagramDes2Gp10Out : in  std_logic;
    sDiagramDes2Gp10Oe  : in  std_logic;
    sDiagramDes3Gp9In  : out std_logic;
    sDiagramDes3Gp9Out : in  std_logic;
    sDiagramDes3Gp9Oe  : in  std_logic;
    sDiagramDes3Gp10In  : out std_logic;
    sDiagramDes3Gp10Out : in  std_logic;
    sDiagramDes3Gp10Oe  : in  std_logic  
  );
end NormalizeSerdesGpio;

architecture rtl of NormalizeSerdesGpio is

begin
  Ch1Gpio: process(sDiagramDes0Gp3Oe, sDiagramDes0Gp5Out, sDiagramDes0Gp2Oe, sDiagramDes0Gp6Out, sDiagramDes0Gp0Oe,
    sDiagramDes0Gp6Oe, sDiagramCh1GpIn, sDiagramDes0Gp3Out, sDiagramDes0Gp1Oe, sDiagramDes0Gp0Out, sDiagramDes0Gp4Out,
    sDiagramDes0Gp4Oe, sDiagramDes0Gp5Oe, sDiagramDes0Gp1Out, sDiagramDes0Gp2Out, sDiagramDes0Gp7Out, sDiagramDes0Gp7Oe) is
  begin
    sDiagramCh1GpOut <= (others => '0');
    sDiagramCh1GpOe  <= (others => '0');
    sDiagramDes0Gp0In   <= sDiagramCh1GpIn(0);
    sDiagramCh1GpOut(0) <= sDiagramDes0Gp0Out;
    sDiagramCh1GpOe(0)  <= sDiagramDes0Gp0Oe;
    sDiagramDes0Gp1In   <= sDiagramCh1GpIn(1);
    sDiagramCh1GpOut(1) <= sDiagramDes0Gp1Out;
    sDiagramCh1GpOe(1)  <= sDiagramDes0Gp1Oe;
    sDiagramDes0Gp2In   <= sDiagramCh1GpIn(2);
    sDiagramCh1GpOut(2) <= sDiagramDes0Gp2Out;
    sDiagramCh1GpOe(2)  <= sDiagramDes0Gp2Oe;
    sDiagramDes0Gp3In   <= sDiagramCh1GpIn(3);
    sDiagramCh1GpOut(3) <= sDiagramDes0Gp3Out;
    sDiagramCh1GpOe(3)  <= sDiagramDes0Gp3Oe;
    sDiagramDes0Gp4In   <= sDiagramCh1GpIn(4);
    sDiagramCh1GpOut(4) <= sDiagramDes0Gp4Out;
    sDiagramCh1GpOe(4)  <= sDiagramDes0Gp4Oe;
    sDiagramDes0Gp5In   <= sDiagramCh1GpIn(5);
    sDiagramCh1GpOut(5) <= sDiagramDes0Gp5Out;
    sDiagramCh1GpOe(5)  <= sDiagramDes0Gp5Oe;
    sDiagramDes0Gp6In   <= sDiagramCh1GpIn(6);
    sDiagramCh1GpOut(6) <= sDiagramDes0Gp6Out;
    sDiagramCh1GpOe(6)  <= sDiagramDes0Gp6Oe;
    sDiagramDes0Gp7In   <= sDiagramCh1GpIn(7);
    sDiagramCh1GpOut(7) <= sDiagramDes0Gp7Out;
    sDiagramCh1GpOe(7)  <= sDiagramDes0Gp7Oe;
  end process Ch1Gpio;

  Ch3Gpio: process(sDiagramDes1Gp6Oe, sDiagramDes1Gp6Out, sDiagramDes1Gp1Out, sDiagramDes1Gp5Out, sDiagramDes1Gp0Oe,
    sDiagramCh3GpIn, sDiagramDes1Gp5Oe, sDiagramDes1Gp0Out, sDiagramDes1Gp2Out, sDiagramDes1Gp4Oe, sDiagramDes1Gp3Out,
    sDiagramDes1Gp4Out, sDiagramDes1Gp3Oe, sDiagramDes1Gp2Oe, sDiagramDes1Gp1Oe, sDiagramDes1Gp7Out, sDiagramDes1Gp7Oe) is
  begin
    sDiagramCh3GpOut <= (others => '0');
    sDiagramCh3GpOe  <= (others => '0');
    sDiagramDes1Gp0In   <= sDiagramCh3GpIn(0);
    sDiagramCh3GpOut(0) <= sDiagramDes1Gp0Out;
    sDiagramCh3GpOe(0)  <= sDiagramDes1Gp0Oe;
    sDiagramDes1Gp1In   <= sDiagramCh3GpIn(1);
    sDiagramCh3GpOut(1) <= sDiagramDes1Gp1Out;
    sDiagramCh3GpOe(1)  <= sDiagramDes1Gp1Oe;
    sDiagramDes1Gp2In   <= sDiagramCh3GpIn(2);
    sDiagramCh3GpOut(2) <= sDiagramDes1Gp2Out;
    sDiagramCh3GpOe(2)  <= sDiagramDes1Gp2Oe;
    sDiagramDes1Gp3In   <= sDiagramCh3GpIn(3);
    sDiagramCh3GpOut(3) <= sDiagramDes1Gp3Out;
    sDiagramCh3GpOe(3)  <= sDiagramDes1Gp3Oe;
    sDiagramDes1Gp4In   <= sDiagramCh3GpIn(4);
    sDiagramCh3GpOut(4) <= sDiagramDes1Gp4Out;
    sDiagramCh3GpOe(4)  <= sDiagramDes1Gp4Oe;
    sDiagramDes1Gp5In   <= sDiagramCh3GpIn(5);
    sDiagramCh3GpOut(5) <= sDiagramDes1Gp5Out;
    sDiagramCh3GpOe(5)  <= sDiagramDes1Gp5Oe;
    sDiagramDes1Gp6In   <= sDiagramCh3GpIn(6);
    sDiagramCh3GpOut(6) <= sDiagramDes1Gp6Out;
    sDiagramCh3GpOe(6)  <= sDiagramDes1Gp6Oe;
    sDiagramDes1Gp7In   <= sDiagramCh3GpIn(7);
    sDiagramCh3GpOut(7) <= sDiagramDes1Gp7Out;
    sDiagramCh3GpOe(7)  <= sDiagramDes1Gp7Oe;
  end process Ch3Gpio;

  Ch5Gpio: process(sDiagramDes2Gp4Out, sDiagramDes2Gp2Out, sDiagramDes2Gp3Oe, sDiagramDes2Gp5Oe, sDiagramDes2Gp0Out,
    sDiagramDes2Gp5Out, sDiagramDes2Gp4Oe, sDiagramDes2Gp6Oe, sDiagramDes2Gp1Oe, sDiagramCh5GpIn, sDiagramDes2Gp0Oe,
    sDiagramDes2Gp2Oe, sDiagramDes2Gp1Out, sDiagramDes2Gp6Out, sDiagramDes2Gp3Out, sDiagramDes2Gp7Out, sDiagramDes2Gp7Oe) is
  begin
    sDiagramCh5GpOut <= (others => '0');
    sDiagramCh5GpOe  <= (others => '0');
    sDiagramDes2Gp0In   <= sDiagramCh5GpIn(0);
    sDiagramCh5GpOut(0) <= sDiagramDes2Gp0Out;
    sDiagramCh5GpOe(0)  <= sDiagramDes2Gp0Oe;
    sDiagramDes2Gp1In   <= sDiagramCh5GpIn(1);
    sDiagramCh5GpOut(1) <= sDiagramDes2Gp1Out;
    sDiagramCh5GpOe(1)  <= sDiagramDes2Gp1Oe;
    sDiagramDes2Gp2In   <= sDiagramCh5GpIn(2);
    sDiagramCh5GpOut(2) <= sDiagramDes2Gp2Out;
    sDiagramCh5GpOe(2)  <= sDiagramDes2Gp2Oe;
    sDiagramDes2Gp3In   <= sDiagramCh5GpIn(3);
    sDiagramCh5GpOut(3) <= sDiagramDes2Gp3Out;
    sDiagramCh5GpOe(3)  <= sDiagramDes2Gp3Oe;
    sDiagramDes2Gp4In   <= sDiagramCh5GpIn(4);
    sDiagramCh5GpOut(4) <= sDiagramDes2Gp4Out;
    sDiagramCh5GpOe(4)  <= sDiagramDes2Gp4Oe;
    sDiagramDes2Gp5In   <= sDiagramCh5GpIn(5);
    sDiagramCh5GpOut(5) <= sDiagramDes2Gp5Out;
    sDiagramCh5GpOe(5)  <= sDiagramDes2Gp5Oe;
    sDiagramDes2Gp6In   <= sDiagramCh5GpIn(6);
    sDiagramCh5GpOut(6) <= sDiagramDes2Gp6Out;
    sDiagramCh5GpOe(6)  <= sDiagramDes2Gp6Oe;
    sDiagramDes2Gp7In   <= sDiagramCh5GpIn(7);
    sDiagramCh5GpOut(7) <= sDiagramDes2Gp7Out;
    sDiagramCh5GpOe(7)  <= sDiagramDes2Gp7Oe;
  end process Ch5Gpio;

  Ch7Gpio: process(sDiagramDes3Gp5Oe, sDiagramCh7GpIn, sDiagramDes3Gp1Oe, sDiagramDes3Gp1Out, sDiagramDes3Gp3Out,
    sDiagramDes3Gp3Oe, sDiagramDes3Gp6Oe, sDiagramDes3Gp6Out, sDiagramDes3Gp2Out, sDiagramDes3Gp0Oe, sDiagramDes3Gp2Oe,
    sDiagramDes3Gp5Out, sDiagramDes3Gp4Out, sDiagramDes3Gp0Out, sDiagramDes3Gp4Oe, sDiagramDes3Gp7Out, sDiagramDes3Gp7Oe) is
  begin
    sDiagramCh7GpOut <= (others => '0');
    sDiagramCh7GpOe  <= (others => '0');
    sDiagramDes3Gp0In   <= sDiagramCh7GpIn(0);
    sDiagramCh7GpOut(0) <= sDiagramDes3Gp0Out;
    sDiagramCh7GpOe(0)  <= sDiagramDes3Gp0Oe;
    sDiagramDes3Gp1In   <= sDiagramCh7GpIn(1);
    sDiagramCh7GpOut(1) <= sDiagramDes3Gp1Out;
    sDiagramCh7GpOe(1)  <= sDiagramDes3Gp1Oe;
    sDiagramDes3Gp2In   <= sDiagramCh7GpIn(2);
    sDiagramCh7GpOut(2) <= sDiagramDes3Gp2Out;
    sDiagramCh7GpOe(2)  <= sDiagramDes3Gp2Oe;
    sDiagramDes3Gp3In   <= sDiagramCh7GpIn(3);
    sDiagramCh7GpOut(3) <= sDiagramDes3Gp3Out;
    sDiagramCh7GpOe(3)  <= sDiagramDes3Gp3Oe;
    sDiagramDes3Gp4In   <= sDiagramCh7GpIn(4);
    sDiagramCh7GpOut(4) <= sDiagramDes3Gp4Out;
    sDiagramCh7GpOe(4)  <= sDiagramDes3Gp4Oe;
    sDiagramDes3Gp5In   <= sDiagramCh7GpIn(5);
    sDiagramCh7GpOut(5) <= sDiagramDes3Gp5Out;
    sDiagramCh7GpOe(5)  <= sDiagramDes3Gp5Oe;
    sDiagramDes3Gp6In   <= sDiagramCh7GpIn(6);
    sDiagramCh7GpOut(6) <= sDiagramDes3Gp6Out;
    sDiagramCh7GpOe(6)  <= sDiagramDes3Gp6Oe;
    sDiagramDes3Gp7In   <= sDiagramCh7GpIn(7);
    sDiagramCh7GpOut(7) <= sDiagramDes3Gp7Out;
    sDiagramCh7GpOe(7)  <= sDiagramDes3Gp7Oe;
  end process Ch7Gpio;

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

  Ch2Gpio: process(sDiagramSer1Gp3Oe, sDiagramSer1Gp1Out, sDiagramSer1Gp0Oe, sDiagramCh2GpIn, sDiagramSer1Gp3Out,
    sDiagramSer1Gp0Out, sDiagramSer1Gp1Oe, sDiagramSer1Gp2Out, sDiagramSer1Gp2Oe) is
  begin
    sDiagramCh2GpOut <= (others => '0');
    sDiagramCh2GpOe  <= (others => '0');
    sDiagramSer1Gp0In   <= sDiagramCh2GpIn(0);
    sDiagramCh2GpOut(0) <= sDiagramSer1Gp0Out;
    sDiagramCh2GpOe(0)  <= sDiagramSer1Gp0Oe;
    sDiagramSer1Gp1In   <= sDiagramCh2GpIn(1);
    sDiagramCh2GpOut(1) <= sDiagramSer1Gp1Out;
    sDiagramCh2GpOe(1)  <= sDiagramSer1Gp1Oe;
    sDiagramSer1Gp2In   <= sDiagramCh2GpIn(2);
    sDiagramCh2GpOut(2) <= sDiagramSer1Gp2Out;
    sDiagramCh2GpOe(2)  <= sDiagramSer1Gp2Oe;
    sDiagramSer1Gp3In   <= sDiagramCh2GpIn(3);
    sDiagramCh2GpOut(3) <= sDiagramSer1Gp3Out;
    sDiagramCh2GpOe(3)  <= sDiagramSer1Gp3Oe;
  end process Ch2Gpio;

  Ch4Gpio: process(sDiagramCh4GpIn, sDiagramSer2Gp3Oe, sDiagramSer2Gp0Out, sDiagramSer2Gp1Out, sDiagramSer2Gp2Oe,
    sDiagramSer2Gp1Oe, sDiagramSer2Gp2Out, sDiagramSer2Gp3Out, sDiagramSer2Gp0Oe) is
  begin
    sDiagramCh4GpOut <= (others => '0');
    sDiagramCh4GpOe  <= (others => '0');
    sDiagramSer2Gp0In   <= sDiagramCh4GpIn(0);
    sDiagramCh4GpOut(0) <= sDiagramSer2Gp0Out;
    sDiagramCh4GpOe(0)  <= sDiagramSer2Gp0Oe;
    sDiagramSer2Gp1In   <= sDiagramCh4GpIn(1);
    sDiagramCh4GpOut(1) <= sDiagramSer2Gp1Out;
    sDiagramCh4GpOe(1)  <= sDiagramSer2Gp1Oe;
    sDiagramSer2Gp2In   <= sDiagramCh4GpIn(2);
    sDiagramCh4GpOut(2) <= sDiagramSer2Gp2Out;
    sDiagramCh4GpOe(2)  <= sDiagramSer2Gp2Oe;
    sDiagramSer2Gp3In   <= sDiagramCh4GpIn(3);
    sDiagramCh4GpOut(3) <= sDiagramSer2Gp3Out;
    sDiagramCh4GpOe(3)  <= sDiagramSer2Gp3Oe;
  end process Ch4Gpio;

  Ch6Gpio: process(sDiagramSer3Gp2Out, sDiagramSer3Gp2Oe, sDiagramSer3Gp3Oe, sDiagramCh6GpIn, sDiagramSer3Gp0Oe,
    sDiagramSer3Gp3Out, sDiagramSer3Gp1Out, sDiagramSer3Gp1Oe, sDiagramSer3Gp0Out) is
  begin
    sDiagramCh6GpOut <= (others => '0');
    sDiagramCh6GpOe  <= (others => '0');
    sDiagramSer3Gp0In   <= sDiagramCh6GpIn(0);
    sDiagramCh6GpOut(0) <= sDiagramSer3Gp0Out;
    sDiagramCh6GpOe(0)  <= sDiagramSer3Gp0Oe;
    sDiagramSer3Gp1In   <= sDiagramCh6GpIn(1);
    sDiagramCh6GpOut(1) <= sDiagramSer3Gp1Out;
    sDiagramCh6GpOe(1)  <= sDiagramSer3Gp1Oe;
    sDiagramSer3Gp2In   <= sDiagramCh6GpIn(2);
    sDiagramCh6GpOut(2) <= sDiagramSer3Gp2Out;
    sDiagramCh6GpOe(2)  <= sDiagramSer3Gp2Oe;
    sDiagramSer3Gp3In   <= sDiagramCh6GpIn(3);
    sDiagramCh6GpOut(3) <= sDiagramSer3Gp3Out;
    sDiagramCh6GpOe(3)  <= sDiagramSer3Gp3Oe;
  end process Ch6Gpio; 

  MiscGpio: process(sDiagramDes0Gp10Oe, sDiagramDes0Gp10Out, sDiagramDes0Gp9Oe, sDiagramDes0Gp9Out, sDiagramDes1Gp10Oe,
    sDiagramDes1Gp10Out, sDiagramDes1Gp9Oe, sDiagramDes1Gp9Out, sDiagramDes2Gp10Oe, sDiagramDes2Gp10Out, sDiagramDes2Gp9Oe,
    sDiagramDes2Gp9Out, sDiagramDes3Gp10Oe, sDiagramDes3Gp10Out, sDiagramDes3Gp9Oe, sDiagramDes3Gp9Out, sDiagramMiscGpIn) is
  begin
    sDiagramMiscGpOut <= (others => '0');
    sDiagramMiscGpOe  <= (others => '0');
    sDiagramDes0Gp9In   <= sDiagramMiscGpIn(1);
    sDiagramMiscGpOut(1) <= sDiagramDes0Gp9Out;
    sDiagramMiscGpOe(1)  <= sDiagramDes0Gp9Oe;
    sDiagramDes0Gp10In   <= sDiagramMiscGpIn(2);
    sDiagramMiscGpOut(2) <= sDiagramDes0Gp10Out;
    sDiagramMiscGpOe(2)  <= sDiagramDes0Gp10Oe;
    sDiagramDes1Gp9In   <= sDiagramMiscGpIn(5);
    sDiagramMiscGpOut(5) <= sDiagramDes1Gp9Out;
    sDiagramMiscGpOe(5)  <= sDiagramDes1Gp9Oe;
    sDiagramDes1Gp10In   <= sDiagramMiscGpIn(6);
    sDiagramMiscGpOut(6) <= sDiagramDes1Gp10Out;
    sDiagramMiscGpOe(6)  <= sDiagramDes1Gp10Oe;
    sDiagramDes2Gp9In   <= sDiagramMiscGpIn(9);
    sDiagramMiscGpOut(9) <= sDiagramDes2Gp9Out;
    sDiagramMiscGpOe(9)  <= sDiagramDes2Gp9Oe;
    sDiagramDes2Gp10In   <= sDiagramMiscGpIn(10);
    sDiagramMiscGpOut(10) <= sDiagramDes2Gp10Out;
    sDiagramMiscGpOe(10)  <= sDiagramDes2Gp10Oe;
    sDiagramDes3Gp9In   <= sDiagramMiscGpIn(13);
    sDiagramMiscGpOut(13) <= sDiagramDes3Gp9Out;
    sDiagramMiscGpOe(13)  <= sDiagramDes3Gp9Oe;
    sDiagramDes3Gp10In   <= sDiagramMiscGpIn(14);
    sDiagramMiscGpOut(14) <= sDiagramDes3Gp10Out;
    sDiagramMiscGpOe(14)  <= sDiagramDes3Gp10Oe;
  end process MiscGpio;
end rtl;
