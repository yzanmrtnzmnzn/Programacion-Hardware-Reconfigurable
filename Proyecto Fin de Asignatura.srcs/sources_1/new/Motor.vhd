----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.06.2025 12:48:16
-- Design Name: 
-- Module Name: Motor_NS - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity Motor is
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        mover : in  STD_LOGIC;
        angle : in  STD_LOGIC;
        pwm   : out STD_LOGIC
    );
end Motor;

architecture Behavioral of Motor is
    constant PERIOD     : integer := 2_000_000;  -- 20ms (50Hz)
    constant MIN_WIDTH  : integer := 100_000;    -- 1ms
    constant MAX_WIDTH  : integer := 200_000;    -- 2ms
    constant NEUTRAL    : integer := 150_000;    -- 1.5ms
    
    signal counter      : integer range 0 to PERIOD-1 := 0;
    signal pulse_length : integer range MIN_WIDTH to MAX_WIDTH := NEUTRAL;
    signal update_timer : integer range 0 to 500_000 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            pulse_length <= NEUTRAL;
            update_timer <= 0;
        elsif rising_edge(clk) then

            if counter = PERIOD-1 then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
            

            if update_timer = 500_000 then 
                update_timer <= 0;
                
                if mover = '1' then
                    if angle = '1' and pulse_length < MAX_WIDTH then
                        pulse_length <= pulse_length + 500;  
                    elsif angle = '0' and pulse_length > MIN_WIDTH then
                        pulse_length <= pulse_length - 500;  
                    end if;
                end if;
            else
                update_timer <= update_timer + 1;
            end if;
        end if;
    end process;
    
    pwm <= '1' when counter < pulse_length else '0';
end Behavioral;

