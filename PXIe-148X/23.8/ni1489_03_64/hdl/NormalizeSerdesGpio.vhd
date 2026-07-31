-------------------------------------------------------------------------------
--
-- File: NormalizeSerdesGpio.vhd
-- Author: Ming Zhi Lim
-- Original Project: NI 148X
-- Date: 6 Jan 2023
--
-------------------------------------------------------------------------------
-- (c) 2023 Copyright National Instruments.
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
    sDiagramMiscGpIn  : in  std_logic_vector(15 downto 0);
    sDiagramMiscGpOut : out std_logic_vector(15 downto 0);
    sDiagramMiscGpOe  : out std_logic_vector(15 downto 0);

    -- Individual Serdes GPIO
    sDiagramDes0Mfp0In  : out std_logic;
    sDiagramDes0Mfp0Out : in  std_logic;
    sDiagramDes0Mfp0Oe  : in  std_logic;
    sDiagramDes0Mfp1In  : out std_logic;
    sDiagramDes0Mfp1Out : in  std_logic;
    sDiagramDes0Mfp1Oe  : in  std_logic;
    sDiagramDes0Mfp2In  : out std_logic;
    sDiagramDes0Mfp3In  : out std_logic;
    sDiagramDes0Mfp4In  : out std_logic;
    sDiagramDes0Mfp4Out : in  std_logic;
    sDiagramDes0Mfp4Oe  : in  std_logic;
    sDiagramDes0Mfp5In  : out std_logic;
    sDiagramDes0Mfp5Out : in  std_logic;
    sDiagramDes0Mfp5Oe  : in  std_logic;
    sDiagramDes0Mfp6In  : out std_logic;
    sDiagramDes0Mfp6Out : in  std_logic;
    sDiagramDes0Mfp6Oe  : in  std_logic;
    sDiagramDes0Mfp7In  : out std_logic;
    sDiagramDes0Mfp7Out : in  std_logic;
    sDiagramDes0Mfp7Oe  : in  std_logic;
    sDiagramDes1Mfp0In  : out std_logic;
    sDiagramDes1Mfp0Out : in  std_logic;
    sDiagramDes1Mfp0Oe  : in  std_logic;
    sDiagramDes1Mfp1In  : out std_logic;
    sDiagramDes1Mfp1Out : in  std_logic;
    sDiagramDes1Mfp1Oe  : in  std_logic;
    sDiagramDes1Mfp2In  : out std_logic;
    sDiagramDes1Mfp3In  : out std_logic;
    sDiagramDes1Mfp4In  : out std_logic;
    sDiagramDes1Mfp4Out : in  std_logic;
    sDiagramDes1Mfp4Oe  : in  std_logic;
    sDiagramDes1Mfp5In  : out std_logic;
    sDiagramDes1Mfp5Out : in  std_logic;
    sDiagramDes1Mfp5Oe  : in  std_logic;
    sDiagramDes1Mfp6In  : out std_logic;
    sDiagramDes1Mfp6Out : in  std_logic;
    sDiagramDes1Mfp6Oe  : in  std_logic;
    sDiagramDes1Mfp7In  : out std_logic;
    sDiagramDes1Mfp7Out : in  std_logic;
    sDiagramDes1Mfp7Oe  : in  std_logic;
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

    sDiagramDes0Mfp8In  : out std_logic;
    sDiagramDes0Mfp8Out : in  std_logic;
    sDiagramDes0Mfp8Oe  : in  std_logic;
    sDiagramDes0Mfp9In  : out std_logic;
    sDiagramDes0Mfp9Out : in  std_logic;
    sDiagramDes0Mfp9Oe  : in  std_logic;
    sDiagramDes0Mfp10In  : out std_logic;
    sDiagramDes0Mfp10Out : in  std_logic;
    sDiagramDes0Mfp10Oe  : in  std_logic;
    sDiagramDes1Mfp8In  : out std_logic;
    sDiagramDes1Mfp8Out : in  std_logic;
    sDiagramDes1Mfp8Oe  : in  std_logic;
    sDiagramDes1Mfp9In  : out std_logic;
    sDiagramDes1Mfp9Out : in  std_logic;
    sDiagramDes1Mfp9Oe  : in  std_logic;
    sDiagramDes1Mfp10In  : out std_logic;
    sDiagramDes1Mfp10Out : in  std_logic;
    sDiagramDes1Mfp10Oe  : in  std_logic
  );
end NormalizeSerdesGpio;

architecture rtl of NormalizeSerdesGpio is

begin

  Ch1Gpio: process(sDiagramDes0Mfp1Oe, sDiagramDes0Mfp1Out, sDiagramDes0Mfp4Oe, sDiagramDes0Mfp5Oe, sDiagramDes0Mfp5Out,
    sDiagramDes0Mfp7Out, sDiagramDes0Mfp4Out, sDiagramDes0Mfp6Oe, sDiagramDes0Mfp6Out, sDiagramDes0Mfp0Out,
    sDiagramDes0Mfp0Oe, sDiagramDes0Mfp7Oe, sDiagramCh1GpIn) is
  begin
    sDiagramCh1GpOut <= (others => '0');
    sDiagramCh1GpOe  <= (others => '0');
    sDiagramDes0Mfp0In   <= sDiagramCh1GpIn(0);
    sDiagramCh1GpOut(0) <= sDiagramDes0Mfp0Out;
    sDiagramCh1GpOe(0)  <= sDiagramDes0Mfp0Oe;
    sDiagramDes0Mfp1In   <= sDiagramCh1GpIn(1);
    sDiagramCh1GpOut(1) <= sDiagramDes0Mfp1Out;
    sDiagramCh1GpOe(1)  <= sDiagramDes0Mfp1Oe;
    sDiagramDes0Mfp2In   <= sDiagramCh1GpIn(2);
    sDiagramDes0Mfp3In   <= sDiagramCh1GpIn(3);
    sDiagramDes0Mfp4In   <= sDiagramCh1GpIn(4);
    sDiagramCh1GpOut(4) <= sDiagramDes0Mfp4Out;
    sDiagramCh1GpOe(4)  <= sDiagramDes0Mfp4Oe;
    sDiagramDes0Mfp5In   <= sDiagramCh1GpIn(5);
    sDiagramCh1GpOut(5) <= sDiagramDes0Mfp5Out;
    sDiagramCh1GpOe(5)  <= sDiagramDes0Mfp5Oe;
    sDiagramDes0Mfp6In   <= sDiagramCh1GpIn(6);
    sDiagramCh1GpOut(6) <= sDiagramDes0Mfp6Out;
    sDiagramCh1GpOe(6)  <= sDiagramDes0Mfp6Oe;
    sDiagramDes0Mfp7In   <= sDiagramCh1GpIn(7);
    sDiagramCh1GpOut(7) <= sDiagramDes0Mfp7Out;
    sDiagramCh1GpOe(7)  <= sDiagramDes0Mfp7Oe;
  end process Ch1Gpio;

  Ch3Gpio: process(sDiagramDes1Mfp4Oe, sDiagramDes1Mfp4Out, sDiagramDes1Mfp1Oe, sDiagramDes1Mfp7Oe, sDiagramDes1Mfp0Oe,
    sDiagramDes1Mfp0Out, sDiagramDes1Mfp1Out, sDiagramDes1Mfp6Out, sDiagramDes1Mfp5Out, sDiagramDes1Mfp5Oe,
    sDiagramDes1Mfp7Out, sDiagramCh3GpIn, sDiagramDes1Mfp6Oe) is
  begin
    sDiagramCh3GpOut <= (others => '0');
    sDiagramCh3GpOe  <= (others => '0');
    sDiagramDes1Mfp0In   <= sDiagramCh3GpIn(0);
    sDiagramCh3GpOut(0) <= sDiagramDes1Mfp0Out;
    sDiagramCh3GpOe(0)  <= sDiagramDes1Mfp0Oe;
    sDiagramDes1Mfp1In   <= sDiagramCh3GpIn(1);
    sDiagramCh3GpOut(1) <= sDiagramDes1Mfp1Out;
    sDiagramCh3GpOe(1)  <= sDiagramDes1Mfp1Oe;
    sDiagramDes1Mfp2In   <= sDiagramCh3GpIn(2);
    sDiagramDes1Mfp3In   <= sDiagramCh3GpIn(3);
    sDiagramDes1Mfp4In   <= sDiagramCh3GpIn(4);
    sDiagramCh3GpOut(4) <= sDiagramDes1Mfp4Out;
    sDiagramCh3GpOe(4)  <= sDiagramDes1Mfp4Oe;
    sDiagramDes1Mfp5In   <= sDiagramCh3GpIn(5);
    sDiagramCh3GpOut(5) <= sDiagramDes1Mfp5Out;
    sDiagramCh3GpOe(5)  <= sDiagramDes1Mfp5Oe;
    sDiagramDes1Mfp6In   <= sDiagramCh3GpIn(6);
    sDiagramCh3GpOut(6) <= sDiagramDes1Mfp6Out;
    sDiagramCh3GpOe(6)  <= sDiagramDes1Mfp6Oe;
    sDiagramDes1Mfp7In   <= sDiagramCh3GpIn(7);
    sDiagramCh3GpOut(7) <= sDiagramDes1Mfp7Out;
    sDiagramCh3GpOe(7)  <= sDiagramDes1Mfp7Oe;
  end process Ch3Gpio;

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

  Ch2Gpio: process(sDiagramSer1Mfp7Oe, sDiagramSer1Mfp6Oe, sDiagramSer1Mfp6Out, sDiagramSer1Mfp4Out, sDiagramSer1Mfp8Oe,
    sDiagramSer1Mfp7Out, sDiagramSer1Mfp0Out, sDiagramSer1Mfp3Out, sDiagramSer1Mfp3Oe, sDiagramSer1Mfp4Oe,
    sDiagramSer1Mfp8Out, sDiagramCh2GpIn, sDiagramSer1Mfp0Oe) is
  begin
    sDiagramCh2GpOut <= (others => '0');
    sDiagramCh2GpOe  <= (others => '0');
    sDiagramSer1Mfp0In   <= sDiagramCh2GpIn(0);
    sDiagramCh2GpOut(0) <= sDiagramSer1Mfp0Out;
    sDiagramCh2GpOe(0)  <= sDiagramSer1Mfp0Oe;
    sDiagramSer1Mfp1In   <= sDiagramCh2GpIn(2);
    sDiagramSer1Mfp2In   <= sDiagramCh2GpIn(3);
    sDiagramSer1Mfp3In   <= sDiagramCh2GpIn(1);
    sDiagramCh2GpOut(1) <= sDiagramSer1Mfp3Out;
    sDiagramCh2GpOe(1)  <= sDiagramSer1Mfp3Oe;
    sDiagramSer1Mfp4In   <= sDiagramCh2GpIn(4);
    sDiagramCh2GpOut(4) <= sDiagramSer1Mfp4Out;
    sDiagramCh2GpOe(4)  <= sDiagramSer1Mfp4Oe;
    sDiagramSer1Mfp6In   <= sDiagramCh2GpIn(5);
    sDiagramCh2GpOut(5) <= sDiagramSer1Mfp6Out;
    sDiagramCh2GpOe(5)  <= sDiagramSer1Mfp6Oe;
    sDiagramSer1Mfp7In   <= sDiagramCh2GpIn(6);
    sDiagramCh2GpOut(6) <= sDiagramSer1Mfp7Out;
    sDiagramCh2GpOe(6)  <= sDiagramSer1Mfp7Oe;
    sDiagramSer1Mfp8In   <= sDiagramCh2GpIn(7);
    sDiagramCh2GpOut(7) <= sDiagramSer1Mfp8Out;
    sDiagramCh2GpOe(7)  <= sDiagramSer1Mfp8Oe;
  end process Ch2Gpio;

  MiscGpio: process(sDiagramDes0Mfp10Oe , sDiagramDes0Mfp10Out, sDiagramDes0Mfp8Oe  , sDiagramDes0Mfp8Out ,
                    sDiagramDes0Mfp9Oe  , sDiagramDes0Mfp9Out , sDiagramDes1Mfp10Oe , sDiagramDes1Mfp10Out,
                    sDiagramDes1Mfp8Oe  , sDiagramDes1Mfp8Out , sDiagramDes1Mfp9Oe  , sDiagramDes1Mfp9Out ,
                    sDiagramMiscGpIn
                    ) is
  begin
    sDiagramMiscGpOut <= (others => '0');
    sDiagramMiscGpOe  <= (others => '0');
    sDiagramDes0Mfp8In   <= sDiagramMiscGpIn(0);
    sDiagramMiscGpOut(0) <= sDiagramDes0Mfp8Out;
    sDiagramMiscGpOe(0)  <= sDiagramDes0Mfp8Oe;
    sDiagramDes0Mfp9In   <= sDiagramMiscGpIn(1);
    sDiagramMiscGpOut(1) <= sDiagramDes0Mfp9Out;
    sDiagramMiscGpOe(1)  <= sDiagramDes0Mfp9Oe;
    sDiagramDes0Mfp10In   <= sDiagramMiscGpIn(2);
    sDiagramMiscGpOut(2) <= sDiagramDes0Mfp10Out;
    sDiagramMiscGpOe(2)  <= sDiagramDes0Mfp10Oe;
    sDiagramDes1Mfp8In   <= sDiagramMiscGpIn(4);
    sDiagramMiscGpOut(4) <= sDiagramDes1Mfp8Out;
    sDiagramMiscGpOe(4)  <= sDiagramDes1Mfp8Oe;
    sDiagramDes1Mfp9In   <= sDiagramMiscGpIn(5);
    sDiagramMiscGpOut(5) <= sDiagramDes1Mfp9Out;
    sDiagramMiscGpOe(5)  <= sDiagramDes1Mfp9Oe;
    sDiagramDes1Mfp10In   <= sDiagramMiscGpIn(6);
    sDiagramMiscGpOut(6) <= sDiagramDes1Mfp10Out;
    sDiagramMiscGpOe(6)  <= sDiagramDes1Mfp10Oe;
  end process MiscGpio;
end rtl;
