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
    sDiagramDes0Mfp0In    : out std_logic;
    sDiagramDes0Mfp0Out   : in  std_logic;
    sDiagramDes0Mfp0Oe    : in  std_logic;
    sDiagramDes0Mfp1In    : out std_logic;
    sDiagramDes0Mfp1Out   : in  std_logic;
    sDiagramDes0Mfp1Oe    : in  std_logic;
    sDiagramDes0Mfp2In    : out std_logic;
    sDiagramDes0Mfp3In    : out std_logic;
    sDiagramDes0Mfp4In    : out std_logic;
    sDiagramDes0Mfp4Out   : in  std_logic;
    sDiagramDes0Mfp4Oe    : in  std_logic;
    sDiagramDes0Mfp5In    : out std_logic;
    sDiagramDes0Mfp5Out   : in  std_logic;
    sDiagramDes0Mfp5Oe    : in  std_logic;
    sDiagramDes0Mfp6In    : out std_logic;
    sDiagramDes0Mfp6Out   : in  std_logic;
    sDiagramDes0Mfp6Oe    : in  std_logic;
    sDiagramDes0Mfp7In    : out std_logic;
    sDiagramDes0Mfp7Out   : in  std_logic;
    sDiagramDes0Mfp7Oe    : in  std_logic;
    sDiagramDes1Mfp0In    : out std_logic;
    sDiagramDes1Mfp0Out   : in  std_logic;
    sDiagramDes1Mfp0Oe    : in  std_logic;
    sDiagramDes1Mfp1In    : out std_logic;
    sDiagramDes1Mfp1Out   : in  std_logic;
    sDiagramDes1Mfp1Oe    : in  std_logic;
    sDiagramDes1Mfp2In    : out std_logic;
    sDiagramDes1Mfp3In    : out std_logic;
    sDiagramDes1Mfp4In    : out std_logic;
    sDiagramDes1Mfp4Out   : in  std_logic;
    sDiagramDes1Mfp4Oe    : in  std_logic;
    sDiagramDes1Mfp5In    : out std_logic;
    sDiagramDes1Mfp5Out   : in  std_logic;
    sDiagramDes1Mfp5Oe    : in  std_logic;
    sDiagramDes1Mfp6In    : out std_logic;
    sDiagramDes1Mfp6Out   : in  std_logic;
    sDiagramDes1Mfp6Oe    : in  std_logic;
    sDiagramDes1Mfp7In    : out std_logic;
    sDiagramDes1Mfp7Out   : in  std_logic;
    sDiagramDes1Mfp7Oe    : in  std_logic;

    sDiagramDes0Mfp8In    : out std_logic;
    sDiagramDes0Mfp8Out   : in  std_logic;
    sDiagramDes0Mfp8Oe    : in  std_logic;
    sDiagramDes0Mfp9In    : out std_logic;
    sDiagramDes0Mfp9Out   : in  std_logic;
    sDiagramDes0Mfp9Oe    : in  std_logic;
    sDiagramDes0Mfp10In   : out std_logic;
    sDiagramDes0Mfp10Out  : in  std_logic;
    sDiagramDes0Mfp10Oe   : in  std_logic;
    sDiagramDes1Mfp8In    : out std_logic;
    sDiagramDes1Mfp8Out   : in  std_logic;
    sDiagramDes1Mfp8Oe    : in  std_logic;
    sDiagramDes1Mfp9In    : out std_logic;
    sDiagramDes1Mfp9Out   : in  std_logic;
    sDiagramDes1Mfp9Oe    : in  std_logic;
    sDiagramDes1Mfp10In   : out std_logic;
    sDiagramDes1Mfp10Out  : in  std_logic;
    sDiagramDes1Mfp10Oe   : in  std_logic
  );
end NormalizeSerdesGpio;

architecture rtl of NormalizeSerdesGpio is

begin
  --vhook_nowarn sDiagramCh0GpIn sDiagramCh2GpIn sDiagramCh4GpIn sDiagramCh6GpIn
  -- Ch02Gpio
  --There is only one deserializer per 2 channels.  The GPIO lines are hooked up on odd channels to the deserialzier.
  --Make those GPIO lines high impedance since they are not used and pulls exist either externally or within the CPLD.
  sDiagramCh0GpOut <= (others => '0');
  sDiagramCh0GpOe  <= (others => '0');
  sDiagramCh2GpOut <= (others => '0');
  sDiagramCh2GpOe  <= (others => '0');

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

  MiscGpio: process(sDiagramDes0Mfp10Oe, sDiagramDes0Mfp10Out, sDiagramDes0Mfp8Oe , sDiagramDes0Mfp8Out ,
                    sDiagramDes0Mfp9Oe ,  sDiagramDes0Mfp9Out, sDiagramDes1Mfp10Oe, sDiagramDes1Mfp10Out,
                    sDiagramDes1Mfp8Oe ,  sDiagramDes1Mfp8Out, sDiagramDes1Mfp9Oe , sDiagramDes1Mfp9Out ,
                    sDiagramMiscGpIn
    ) is
  begin
    sDiagramMiscGpOut <= (others => '0');
    sDiagramMiscGpOe  <= (others => '0');
    sDiagramDes0Mfp8In    <= sDiagramMiscGpIn(0);
    sDiagramMiscGpOut(0)  <= sDiagramDes0Mfp8Out;
    sDiagramMiscGpOe(0)   <= sDiagramDes0Mfp8Oe;
    sDiagramDes0Mfp9In    <= sDiagramMiscGpIn(1);
    sDiagramMiscGpOut(1)  <= sDiagramDes0Mfp9Out;
    sDiagramMiscGpOe(1)   <= sDiagramDes0Mfp9Oe;
    sDiagramDes0Mfp10In   <= sDiagramMiscGpIn(2);
    sDiagramMiscGpOut(2)  <= sDiagramDes0Mfp10Out;
    sDiagramMiscGpOe(2)   <= sDiagramDes0Mfp10Oe;
    sDiagramDes1Mfp8In    <= sDiagramMiscGpIn(4);
    sDiagramMiscGpOut(4)  <= sDiagramDes1Mfp8Out;
    sDiagramMiscGpOe(4)   <= sDiagramDes1Mfp8Oe;
    sDiagramDes1Mfp9In    <= sDiagramMiscGpIn(5);
    sDiagramMiscGpOut(5)  <= sDiagramDes1Mfp9Out;
    sDiagramMiscGpOe(5)   <= sDiagramDes1Mfp9Oe;
    sDiagramDes1Mfp10In   <= sDiagramMiscGpIn(6);
    sDiagramMiscGpOut(6)  <= sDiagramDes1Mfp10Out;
    sDiagramMiscGpOe(6)   <= sDiagramDes1Mfp10Oe;
    sDiagramMiscGpOut(8)  <= '0';
    sDiagramMiscGpOe(8)   <= '0';
    sDiagramMiscGpOut(9)  <= '0';
    sDiagramMiscGpOe(9)   <= '0';
    sDiagramMiscGpOut(10) <= '0';
    sDiagramMiscGpOe(10)  <= '0';
    sDiagramMiscGpOut(12) <= '0';
    sDiagramMiscGpOe(12)  <= '0';
    sDiagramMiscGpOut(13) <= '0';
    sDiagramMiscGpOe(13)  <= '0';
    sDiagramMiscGpOut(14) <= '0';
    sDiagramMiscGpOe(14)  <= '0';
  end process MiscGpio;
end rtl;
