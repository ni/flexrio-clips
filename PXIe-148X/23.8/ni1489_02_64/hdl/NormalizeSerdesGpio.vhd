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
    sDiagramSer3Mfp8Oe  : in  std_logic
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

  --vhook_nowarn sDiagramMiscGpIn
  sDiagramMiscGpOut <= (others => '0');
  sDiagramMiscGpOe  <= (others => '0');
end rtl;
