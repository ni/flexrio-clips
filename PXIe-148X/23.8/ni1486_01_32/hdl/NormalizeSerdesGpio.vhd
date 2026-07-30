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
    sDiagramDes4Gp0In  : out std_logic;
    sDiagramDes4Gp0Out : in  std_logic;
    sDiagramDes4Gp0Oe  : in  std_logic;
    sDiagramDes4Gp1In  : out std_logic;
    sDiagramDes4Gp1Out : in  std_logic;
    sDiagramDes4Gp1Oe  : in  std_logic;
    sDiagramDes4Gp2In  : out std_logic;
    sDiagramDes4Gp2Out : in  std_logic;
    sDiagramDes4Gp2Oe  : in  std_logic;
    sDiagramDes4Gp3In  : out std_logic;
    sDiagramDes4Gp3Out : in  std_logic;
    sDiagramDes4Gp3Oe  : in  std_logic;
    sDiagramDes4Gp4In  : out std_logic;
    sDiagramDes4Gp4Out : in  std_logic;
    sDiagramDes4Gp4Oe  : in  std_logic;
    sDiagramDes4Gp5In  : out std_logic;
    sDiagramDes4Gp5Out : in  std_logic;
    sDiagramDes4Gp5Oe  : in  std_logic;
    sDiagramDes4Gp6In  : out std_logic;
    sDiagramDes4Gp6Out : in  std_logic;
    sDiagramDes4Gp6Oe  : in  std_logic;
    sDiagramDes5Gp0In  : out std_logic;
    sDiagramDes5Gp0Out : in  std_logic;
    sDiagramDes5Gp0Oe  : in  std_logic;
    sDiagramDes5Gp1In  : out std_logic;
    sDiagramDes5Gp1Out : in  std_logic;
    sDiagramDes5Gp1Oe  : in  std_logic;
    sDiagramDes5Gp2In  : out std_logic;
    sDiagramDes5Gp2Out : in  std_logic;
    sDiagramDes5Gp2Oe  : in  std_logic;
    sDiagramDes5Gp3In  : out std_logic;
    sDiagramDes5Gp3Out : in  std_logic;
    sDiagramDes5Gp3Oe  : in  std_logic;
    sDiagramDes5Gp4In  : out std_logic;
    sDiagramDes5Gp4Out : in  std_logic;
    sDiagramDes5Gp4Oe  : in  std_logic;
    sDiagramDes5Gp5In  : out std_logic;
    sDiagramDes5Gp5Out : in  std_logic;
    sDiagramDes5Gp5Oe  : in  std_logic;
    sDiagramDes5Gp6In  : out std_logic;
    sDiagramDes5Gp6Out : in  std_logic;
    sDiagramDes5Gp6Oe  : in  std_logic;
    sDiagramDes6Gp0In  : out std_logic;
    sDiagramDes6Gp0Out : in  std_logic;
    sDiagramDes6Gp0Oe  : in  std_logic;
    sDiagramDes6Gp1In  : out std_logic;
    sDiagramDes6Gp1Out : in  std_logic;
    sDiagramDes6Gp1Oe  : in  std_logic;
    sDiagramDes6Gp2In  : out std_logic;
    sDiagramDes6Gp2Out : in  std_logic;
    sDiagramDes6Gp2Oe  : in  std_logic;
    sDiagramDes6Gp3In  : out std_logic;
    sDiagramDes6Gp3Out : in  std_logic;
    sDiagramDes6Gp3Oe  : in  std_logic;
    sDiagramDes6Gp4In  : out std_logic;
    sDiagramDes6Gp4Out : in  std_logic;
    sDiagramDes6Gp4Oe  : in  std_logic;
    sDiagramDes6Gp5In  : out std_logic;
    sDiagramDes6Gp5Out : in  std_logic;
    sDiagramDes6Gp5Oe  : in  std_logic;
    sDiagramDes6Gp6In  : out std_logic;
    sDiagramDes6Gp6Out : in  std_logic;
    sDiagramDes6Gp6Oe  : in  std_logic;
    sDiagramDes7Gp0In  : out std_logic;
    sDiagramDes7Gp0Out : in  std_logic;
    sDiagramDes7Gp0Oe  : in  std_logic;
    sDiagramDes7Gp1In  : out std_logic;
    sDiagramDes7Gp1Out : in  std_logic;
    sDiagramDes7Gp1Oe  : in  std_logic;
    sDiagramDes7Gp2In  : out std_logic;
    sDiagramDes7Gp2Out : in  std_logic;
    sDiagramDes7Gp2Oe  : in  std_logic;
    sDiagramDes7Gp3In  : out std_logic;
    sDiagramDes7Gp3Out : in  std_logic;
    sDiagramDes7Gp3Oe  : in  std_logic;
    sDiagramDes7Gp4In  : out std_logic;
    sDiagramDes7Gp4Out : in  std_logic;
    sDiagramDes7Gp4Oe  : in  std_logic;
    sDiagramDes7Gp5In  : out std_logic;
    sDiagramDes7Gp5Out : in  std_logic;
    sDiagramDes7Gp5Oe  : in  std_logic;
    sDiagramDes7Gp6In  : out std_logic;
    sDiagramDes7Gp6Out : in  std_logic;
    sDiagramDes7Gp6Oe  : in  std_logic;

    -- Individual Status Signals
    sDiagramDes0Lock   : out std_logic;
    sDiagramDes0Pass   : out std_logic;
    sDiagramDes1Lock   : out std_logic;
    sDiagramDes1Pass   : out std_logic;
    sDiagramDes2Lock   : out std_logic;
    sDiagramDes2Pass   : out std_logic;
    sDiagramDes3Lock   : out std_logic;
    sDiagramDes3Pass   : out std_logic;
    sDiagramDes4Lock   : out std_logic;
    sDiagramDes4Pass   : out std_logic;
    sDiagramDes5Lock   : out std_logic;
    sDiagramDes5Pass   : out std_logic;
    sDiagramDes6Lock   : out std_logic;
    sDiagramDes6Pass   : out std_logic;
    sDiagramDes7Lock   : out std_logic;
    sDiagramDes7Pass   : out std_logic
  );
end NormalizeSerdesGpio;

architecture rtl of NormalizeSerdesGpio is

begin
  Ch0Gpio: process(sDiagramDes0Gp0Oe, sDiagramDes0Gp5Out, sDiagramDes0Gp2Out, sDiagramDes0Gp4Oe, sDiagramDes0Gp0Out,
    sDiagramDes0Gp6Out, sDiagramDes0Gp1Oe, sDiagramDes0Gp6Oe, sDiagramDes0Gp5Oe, sDiagramDes0Gp1Out, sDiagramDes0Gp2Oe,
    sDiagramDes0Gp4Out, sDiagramDes0Gp3Out, sDiagramCh0GpIn, sDiagramDes0Gp3Oe) is
  begin
    sDiagramCh0GpOut <= (others => '0');
    sDiagramCh0GpOe  <= (others => '0');
    sDiagramDes0Gp0In   <= sDiagramCh0GpIn(0);
    sDiagramCh0GpOut(0) <= sDiagramDes0Gp0Out;
    sDiagramCh0GpOe(0)  <= sDiagramDes0Gp0Oe;
    sDiagramDes0Gp1In   <= sDiagramCh0GpIn(1);
    sDiagramCh0GpOut(1) <= sDiagramDes0Gp1Out;
    sDiagramCh0GpOe(1)  <= sDiagramDes0Gp1Oe;
    sDiagramDes0Gp2In   <= sDiagramCh0GpIn(2);
    sDiagramCh0GpOut(2) <= sDiagramDes0Gp2Out;
    sDiagramCh0GpOe(2)  <= sDiagramDes0Gp2Oe;
    sDiagramDes0Gp3In   <= sDiagramCh0GpIn(3);
    sDiagramCh0GpOut(3) <= sDiagramDes0Gp3Out;
    sDiagramCh0GpOe(3)  <= sDiagramDes0Gp3Oe;
    sDiagramDes0Gp4In   <= sDiagramCh0GpIn(4);
    sDiagramCh0GpOut(4) <= sDiagramDes0Gp4Out;
    sDiagramCh0GpOe(4)  <= sDiagramDes0Gp4Oe;
    sDiagramDes0Gp5In   <= sDiagramCh0GpIn(5);
    sDiagramCh0GpOut(5) <= sDiagramDes0Gp5Out;
    sDiagramCh0GpOe(5)  <= sDiagramDes0Gp5Oe;
    sDiagramDes0Gp6In   <= sDiagramCh0GpIn(6);
    sDiagramCh0GpOut(6) <= sDiagramDes0Gp6Out;
    sDiagramCh0GpOe(6)  <= sDiagramDes0Gp6Oe;
  end process Ch0Gpio;

  Ch1Gpio: process(sDiagramDes1Gp0Out, sDiagramDes1Gp6Oe, sDiagramDes1Gp0Oe, sDiagramDes1Gp5Oe, sDiagramDes1Gp4Out,
    sDiagramDes1Gp6Out, sDiagramDes1Gp4Oe, sDiagramDes1Gp2Out, sDiagramDes1Gp5Out, sDiagramDes1Gp3Oe, sDiagramDes1Gp1Out,
    sDiagramDes1Gp3Out, sDiagramDes1Gp1Oe, sDiagramCh1GpIn, sDiagramDes1Gp2Oe) is
  begin
    sDiagramCh1GpOut <= (others => '0');
    sDiagramCh1GpOe  <= (others => '0');
    sDiagramDes1Gp0In   <= sDiagramCh1GpIn(0);
    sDiagramCh1GpOut(0) <= sDiagramDes1Gp0Out;
    sDiagramCh1GpOe(0)  <= sDiagramDes1Gp0Oe;
    sDiagramDes1Gp1In   <= sDiagramCh1GpIn(1);
    sDiagramCh1GpOut(1) <= sDiagramDes1Gp1Out;
    sDiagramCh1GpOe(1)  <= sDiagramDes1Gp1Oe;
    sDiagramDes1Gp2In   <= sDiagramCh1GpIn(2);
    sDiagramCh1GpOut(2) <= sDiagramDes1Gp2Out;
    sDiagramCh1GpOe(2)  <= sDiagramDes1Gp2Oe;
    sDiagramDes1Gp3In   <= sDiagramCh1GpIn(3);
    sDiagramCh1GpOut(3) <= sDiagramDes1Gp3Out;
    sDiagramCh1GpOe(3)  <= sDiagramDes1Gp3Oe;
    sDiagramDes1Gp4In   <= sDiagramCh1GpIn(4);
    sDiagramCh1GpOut(4) <= sDiagramDes1Gp4Out;
    sDiagramCh1GpOe(4)  <= sDiagramDes1Gp4Oe;
    sDiagramDes1Gp5In   <= sDiagramCh1GpIn(5);
    sDiagramCh1GpOut(5) <= sDiagramDes1Gp5Out;
    sDiagramCh1GpOe(5)  <= sDiagramDes1Gp5Oe;
    sDiagramDes1Gp6In   <= sDiagramCh1GpIn(6);
    sDiagramCh1GpOut(6) <= sDiagramDes1Gp6Out;
    sDiagramCh1GpOe(6)  <= sDiagramDes1Gp6Oe;
  end process Ch1Gpio;

  Ch2Gpio: process(sDiagramDes2Gp1Out, sDiagramDes2Gp1Oe, sDiagramDes2Gp4Oe, sDiagramDes2Gp5Out, sDiagramDes2Gp5Oe,
    sDiagramDes2Gp6Oe, sDiagramDes2Gp3Out, sDiagramDes2Gp4Out, sDiagramDes2Gp2Oe, sDiagramDes2Gp6Out, sDiagramDes2Gp0Out,
    sDiagramDes2Gp2Out, sDiagramDes2Gp0Oe, sDiagramCh2GpIn, sDiagramDes2Gp3Oe) is
  begin
    sDiagramCh2GpOut <= (others => '0');
    sDiagramCh2GpOe  <= (others => '0');
    sDiagramDes2Gp0In   <= sDiagramCh2GpIn(0);
    sDiagramCh2GpOut(0) <= sDiagramDes2Gp0Out;
    sDiagramCh2GpOe(0)  <= sDiagramDes2Gp0Oe;
    sDiagramDes2Gp1In   <= sDiagramCh2GpIn(1);
    sDiagramCh2GpOut(1) <= sDiagramDes2Gp1Out;
    sDiagramCh2GpOe(1)  <= sDiagramDes2Gp1Oe;
    sDiagramDes2Gp2In   <= sDiagramCh2GpIn(2);
    sDiagramCh2GpOut(2) <= sDiagramDes2Gp2Out;
    sDiagramCh2GpOe(2)  <= sDiagramDes2Gp2Oe;
    sDiagramDes2Gp3In   <= sDiagramCh2GpIn(3);
    sDiagramCh2GpOut(3) <= sDiagramDes2Gp3Out;
    sDiagramCh2GpOe(3)  <= sDiagramDes2Gp3Oe;
    sDiagramDes2Gp4In   <= sDiagramCh2GpIn(4);
    sDiagramCh2GpOut(4) <= sDiagramDes2Gp4Out;
    sDiagramCh2GpOe(4)  <= sDiagramDes2Gp4Oe;
    sDiagramDes2Gp5In   <= sDiagramCh2GpIn(5);
    sDiagramCh2GpOut(5) <= sDiagramDes2Gp5Out;
    sDiagramCh2GpOe(5)  <= sDiagramDes2Gp5Oe;
    sDiagramDes2Gp6In   <= sDiagramCh2GpIn(6);
    sDiagramCh2GpOut(6) <= sDiagramDes2Gp6Out;
    sDiagramCh2GpOe(6)  <= sDiagramDes2Gp6Oe;
  end process Ch2Gpio;

  Ch3Gpio: process(sDiagramDes3Gp1Out, sDiagramDes3Gp6Oe, sDiagramDes3Gp2Out, sDiagramDes3Gp1Oe, sDiagramDes3Gp4Oe,
    sDiagramDes3Gp3Oe, sDiagramDes3Gp6Out, sDiagramDes3Gp0Oe, sDiagramDes3Gp4Out, sDiagramDes3Gp5Oe, sDiagramCh3GpIn,
    sDiagramDes3Gp0Out, sDiagramDes3Gp2Oe, sDiagramDes3Gp5Out, sDiagramDes3Gp3Out) is
  begin
    sDiagramCh3GpOut <= (others => '0');
    sDiagramCh3GpOe  <= (others => '0');
    sDiagramDes3Gp0In   <= sDiagramCh3GpIn(0);
    sDiagramCh3GpOut(0) <= sDiagramDes3Gp0Out;
    sDiagramCh3GpOe(0)  <= sDiagramDes3Gp0Oe;
    sDiagramDes3Gp1In   <= sDiagramCh3GpIn(1);
    sDiagramCh3GpOut(1) <= sDiagramDes3Gp1Out;
    sDiagramCh3GpOe(1)  <= sDiagramDes3Gp1Oe;
    sDiagramDes3Gp2In   <= sDiagramCh3GpIn(2);
    sDiagramCh3GpOut(2) <= sDiagramDes3Gp2Out;
    sDiagramCh3GpOe(2)  <= sDiagramDes3Gp2Oe;
    sDiagramDes3Gp3In   <= sDiagramCh3GpIn(3);
    sDiagramCh3GpOut(3) <= sDiagramDes3Gp3Out;
    sDiagramCh3GpOe(3)  <= sDiagramDes3Gp3Oe;
    sDiagramDes3Gp4In   <= sDiagramCh3GpIn(4);
    sDiagramCh3GpOut(4) <= sDiagramDes3Gp4Out;
    sDiagramCh3GpOe(4)  <= sDiagramDes3Gp4Oe;
    sDiagramDes3Gp5In   <= sDiagramCh3GpIn(5);
    sDiagramCh3GpOut(5) <= sDiagramDes3Gp5Out;
    sDiagramCh3GpOe(5)  <= sDiagramDes3Gp5Oe;
    sDiagramDes3Gp6In   <= sDiagramCh3GpIn(6);
    sDiagramCh3GpOut(6) <= sDiagramDes3Gp6Out;
    sDiagramCh3GpOe(6)  <= sDiagramDes3Gp6Oe;
  end process Ch3Gpio;

  Ch4Gpio: process(sDiagramDes4Gp3Out, sDiagramDes4Gp3Oe, sDiagramDes4Gp6Oe, sDiagramDes4Gp2Oe, sDiagramDes4Gp5Out,
    sDiagramDes4Gp4Oe, sDiagramDes4Gp1Out, sDiagramDes4Gp6Out, sDiagramDes4Gp0Oe, sDiagramDes4Gp4Out, sDiagramDes4Gp2Out,
    sDiagramDes4Gp0Out, sDiagramCh4GpIn, sDiagramDes4Gp5Oe, sDiagramDes4Gp1Oe) is
  begin
    sDiagramCh4GpOut <= (others => '0');
    sDiagramCh4GpOe  <= (others => '0');
    sDiagramDes4Gp0In   <= sDiagramCh4GpIn(0);
    sDiagramCh4GpOut(0) <= sDiagramDes4Gp0Out;
    sDiagramCh4GpOe(0)  <= sDiagramDes4Gp0Oe;
    sDiagramDes4Gp1In   <= sDiagramCh4GpIn(1);
    sDiagramCh4GpOut(1) <= sDiagramDes4Gp1Out;
    sDiagramCh4GpOe(1)  <= sDiagramDes4Gp1Oe;
    sDiagramDes4Gp2In   <= sDiagramCh4GpIn(2);
    sDiagramCh4GpOut(2) <= sDiagramDes4Gp2Out;
    sDiagramCh4GpOe(2)  <= sDiagramDes4Gp2Oe;
    sDiagramDes4Gp3In   <= sDiagramCh4GpIn(3);
    sDiagramCh4GpOut(3) <= sDiagramDes4Gp3Out;
    sDiagramCh4GpOe(3)  <= sDiagramDes4Gp3Oe;
    sDiagramDes4Gp4In   <= sDiagramCh4GpIn(4);
    sDiagramCh4GpOut(4) <= sDiagramDes4Gp4Out;
    sDiagramCh4GpOe(4)  <= sDiagramDes4Gp4Oe;
    sDiagramDes4Gp5In   <= sDiagramCh4GpIn(5);
    sDiagramCh4GpOut(5) <= sDiagramDes4Gp5Out;
    sDiagramCh4GpOe(5)  <= sDiagramDes4Gp5Oe;
    sDiagramDes4Gp6In   <= sDiagramCh4GpIn(6);
    sDiagramCh4GpOut(6) <= sDiagramDes4Gp6Out;
    sDiagramCh4GpOe(6)  <= sDiagramDes4Gp6Oe;
  end process Ch4Gpio;

  Ch5Gpio: process(sDiagramDes5Gp4Oe, sDiagramDes5Gp0Oe, sDiagramDes5Gp3Oe, sDiagramDes5Gp4Out, sDiagramDes5Gp2Oe,
    sDiagramDes5Gp5Oe, sDiagramDes5Gp0Out, sDiagramDes5Gp6Oe, sDiagramDes5Gp2Out, sDiagramCh5GpIn, sDiagramDes5Gp6Out,
    sDiagramDes5Gp1Out, sDiagramDes5Gp3Out, sDiagramDes5Gp1Oe, sDiagramDes5Gp5Out) is
  begin
    sDiagramCh5GpOut <= (others => '0');
    sDiagramCh5GpOe  <= (others => '0');
    sDiagramDes5Gp0In   <= sDiagramCh5GpIn(0);
    sDiagramCh5GpOut(0) <= sDiagramDes5Gp0Out;
    sDiagramCh5GpOe(0)  <= sDiagramDes5Gp0Oe;
    sDiagramDes5Gp1In   <= sDiagramCh5GpIn(1);
    sDiagramCh5GpOut(1) <= sDiagramDes5Gp1Out;
    sDiagramCh5GpOe(1)  <= sDiagramDes5Gp1Oe;
    sDiagramDes5Gp2In   <= sDiagramCh5GpIn(2);
    sDiagramCh5GpOut(2) <= sDiagramDes5Gp2Out;
    sDiagramCh5GpOe(2)  <= sDiagramDes5Gp2Oe;
    sDiagramDes5Gp3In   <= sDiagramCh5GpIn(3);
    sDiagramCh5GpOut(3) <= sDiagramDes5Gp3Out;
    sDiagramCh5GpOe(3)  <= sDiagramDes5Gp3Oe;
    sDiagramDes5Gp4In   <= sDiagramCh5GpIn(4);
    sDiagramCh5GpOut(4) <= sDiagramDes5Gp4Out;
    sDiagramCh5GpOe(4)  <= sDiagramDes5Gp4Oe;
    sDiagramDes5Gp5In   <= sDiagramCh5GpIn(5);
    sDiagramCh5GpOut(5) <= sDiagramDes5Gp5Out;
    sDiagramCh5GpOe(5)  <= sDiagramDes5Gp5Oe;
    sDiagramDes5Gp6In   <= sDiagramCh5GpIn(6);
    sDiagramCh5GpOut(6) <= sDiagramDes5Gp6Out;
    sDiagramCh5GpOe(6)  <= sDiagramDes5Gp6Oe;
  end process Ch5Gpio;

  Ch6Gpio: process(sDiagramDes6Gp5Out, sDiagramDes6Gp6Out, sDiagramDes6Gp5Oe, sDiagramDes6Gp1Oe, sDiagramDes6Gp2Oe,
    sDiagramDes6Gp6Oe, sDiagramDes6Gp3Oe, sDiagramDes6Gp4Oe, sDiagramDes6Gp1Out, sDiagramDes6Gp3Out, sDiagramCh6GpIn,
    sDiagramDes6Gp0Out, sDiagramDes6Gp2Out, sDiagramDes6Gp0Oe, sDiagramDes6Gp4Out) is
  begin
    sDiagramCh6GpOut <= (others => '0');
    sDiagramCh6GpOe  <= (others => '0');
    sDiagramDes6Gp0In   <= sDiagramCh6GpIn(0);
    sDiagramCh6GpOut(0) <= sDiagramDes6Gp0Out;
    sDiagramCh6GpOe(0)  <= sDiagramDes6Gp0Oe;
    sDiagramDes6Gp1In   <= sDiagramCh6GpIn(1);
    sDiagramCh6GpOut(1) <= sDiagramDes6Gp1Out;
    sDiagramCh6GpOe(1)  <= sDiagramDes6Gp1Oe;
    sDiagramDes6Gp2In   <= sDiagramCh6GpIn(2);
    sDiagramCh6GpOut(2) <= sDiagramDes6Gp2Out;
    sDiagramCh6GpOe(2)  <= sDiagramDes6Gp2Oe;
    sDiagramDes6Gp3In   <= sDiagramCh6GpIn(3);
    sDiagramCh6GpOut(3) <= sDiagramDes6Gp3Out;
    sDiagramCh6GpOe(3)  <= sDiagramDes6Gp3Oe;
    sDiagramDes6Gp4In   <= sDiagramCh6GpIn(4);
    sDiagramCh6GpOut(4) <= sDiagramDes6Gp4Out;
    sDiagramCh6GpOe(4)  <= sDiagramDes6Gp4Oe;
    sDiagramDes6Gp5In   <= sDiagramCh6GpIn(5);
    sDiagramCh6GpOut(5) <= sDiagramDes6Gp5Out;
    sDiagramCh6GpOe(5)  <= sDiagramDes6Gp5Oe;
    sDiagramDes6Gp6In   <= sDiagramCh6GpIn(6);
    sDiagramCh6GpOut(6) <= sDiagramDes6Gp6Out;
    sDiagramCh6GpOe(6)  <= sDiagramDes6Gp6Oe;
  end process Ch6Gpio;

  Ch7Gpio: process(sDiagramDes7Gp1Oe, sDiagramDes7Gp4Out, sDiagramDes7Gp3Out, sDiagramDes7Gp5Oe, sDiagramDes7Gp1Out,
    sDiagramDes7Gp0Oe, sDiagramDes7Gp4Oe, sDiagramDes7Gp6Out, sDiagramDes7Gp6Oe, sDiagramCh7GpIn, sDiagramDes7Gp3Oe,
    sDiagramDes7Gp5Out, sDiagramDes7Gp2Out, sDiagramDes7Gp0Out, sDiagramDes7Gp2Oe) is
  begin
    sDiagramCh7GpOut <= (others => '0');
    sDiagramCh7GpOe  <= (others => '0');
    sDiagramDes7Gp0In   <= sDiagramCh7GpIn(0);
    sDiagramCh7GpOut(0) <= sDiagramDes7Gp0Out;
    sDiagramCh7GpOe(0)  <= sDiagramDes7Gp0Oe;
    sDiagramDes7Gp1In   <= sDiagramCh7GpIn(1);
    sDiagramCh7GpOut(1) <= sDiagramDes7Gp1Out;
    sDiagramCh7GpOe(1)  <= sDiagramDes7Gp1Oe;
    sDiagramDes7Gp2In   <= sDiagramCh7GpIn(2);
    sDiagramCh7GpOut(2) <= sDiagramDes7Gp2Out;
    sDiagramCh7GpOe(2)  <= sDiagramDes7Gp2Oe;
    sDiagramDes7Gp3In   <= sDiagramCh7GpIn(3);
    sDiagramCh7GpOut(3) <= sDiagramDes7Gp3Out;
    sDiagramCh7GpOe(3)  <= sDiagramDes7Gp3Oe;
    sDiagramDes7Gp4In   <= sDiagramCh7GpIn(4);
    sDiagramCh7GpOut(4) <= sDiagramDes7Gp4Out;
    sDiagramCh7GpOe(4)  <= sDiagramDes7Gp4Oe;
    sDiagramDes7Gp5In   <= sDiagramCh7GpIn(5);
    sDiagramCh7GpOut(5) <= sDiagramDes7Gp5Out;
    sDiagramCh7GpOe(5)  <= sDiagramDes7Gp5Oe;
    sDiagramDes7Gp6In   <= sDiagramCh7GpIn(6);
    sDiagramCh7GpOut(6) <= sDiagramDes7Gp6Out;
    sDiagramCh7GpOe(6)  <= sDiagramDes7Gp6Oe;
  end process Ch7Gpio;

  MiscGpio: process(sDiagramMiscGpIn) is
  begin
    sDiagramMiscGpOut <= (others => '0');
    sDiagramMiscGpOe  <= (others => '0');
    sDiagramDes0Lock  <= sDiagramMiscGpIn(2);
    sDiagramDes0Pass  <= sDiagramMiscGpIn(6);
    sDiagramDes1Lock  <= sDiagramMiscGpIn(7);
    sDiagramDes1Pass  <= sDiagramMiscGpIn(3);
    sDiagramDes2Lock  <= sDiagramMiscGpIn(0);
    sDiagramDes2Pass  <= sDiagramMiscGpIn(1);
    sDiagramDes3Lock  <= sDiagramMiscGpIn(5);
    sDiagramDes3Pass  <= sDiagramMiscGpIn(4);
    sDiagramDes4Lock  <= sDiagramMiscGpIn(10);
    sDiagramDes4Pass  <= sDiagramMiscGpIn(14);
    sDiagramDes5Lock  <= sDiagramMiscGpIn(15);
    sDiagramDes5Pass  <= sDiagramMiscGpIn(11);
    sDiagramDes6Lock  <= sDiagramMiscGpIn(8);
    sDiagramDes6Pass  <= sDiagramMiscGpIn(9);
    sDiagramDes7Lock  <= sDiagramMiscGpIn(13);
    sDiagramDes7Pass  <= sDiagramMiscGpIn(12);
  end process MiscGpio;
end rtl;
