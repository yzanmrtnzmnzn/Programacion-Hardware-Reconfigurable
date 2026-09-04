
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.06.2025 21:34:11
-- Design Name: 
-- Module Name: Ldrs - Behavioral
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

entity Ldrs is
    Port (
        clk       : in  std_logic;
        enable    : in  std_logic;
        ADC_out   : in  std_logic;          -- Señal del ADC externo (entrada al ADC_top)
        ADC_in    : out std_logic;          -- Salida hacia ADC externo (del ADC_top)
        ADCclk    : out std_logic;          -- Reloj generado para ADC (del ADC_top)
        CS        : out std_logic;          -- Señal conv del ADC_top
        seg       : out std_logic_vector(6 downto 0); -- Para display (opcional)
        an        : out std_logic_vector(3 downto 0);  -- Para display (opcional)
        led0_out : out std_logic;
        led1_out : out std_logic;
        led2_out : out std_logic;
        led3_out : out std_logic
    );
end Ldrs;


architecture Behavioral of Ldrs is

        
        signal led2, led3 : std_logic;
        signal I1, I2, I3 : std_logic := '0';
        signal done : std_logic := '0';
        
        signal ADCclk_s : std_logic := '0';
        signal clk_div : integer := 0;
        
        signal data_out  : std_logic_vector(9 downto 0);
        signal dataN  :  std_logic_vector(9 downto 0);
        signal dataS  :  std_logic_vector(9 downto 0);
        signal dataE  :  std_logic_vector(9 downto 0);
        signal dataO  :  std_logic_vector(9 downto 0);
        
            -- FSM para seleccionar canal
        type state_type is (CH0, WAIT0, CH1, WAIT1, CH2, WAIT2, CH3, WAIT3);
        signal state : state_type := CH0;
             -- Comparador
        signal comparacion : std_logic_vector(3 downto 0) := (others => '0');
        
        signal refresh_counter : unsigned(15 downto 0) := (others => '0');
        signal display_select  : unsigned(1 downto 0) := (others => '0');
        
        constant seg_0 : std_logic_vector(6 downto 0) := "1000000"; -- muestra '0'
        constant seg_1 : std_logic_vector(6 downto 0) := "1111001"; -- muestra '1'

begin
    
    ADCclk  <= ADCclk_s;
    led0_out <= comparacion(0);
    led1_out <= comparacion(1);
    led2_out <= comparacion(2);
    led3_out <= comparacion(3);
    
adc_inst : entity work.ADC
        port map (
            ADCclk      => ADCclk_s,
            enable   => enable,
            I1       => I1,
            I2       => I2,
            I3       => I3,
            CS       => CS,
            done     => done,
            ADC_in   => ADC_in,
            ADC_out  => ADC_out,
            data_out => data_out
        );
        
    process(clk)
    begin
        if rising_edge(clk) then
            clk_div <= clk_div + 1;
            if clk_div = 50 then   -- 100 MHz / (2 * 50) = 1 MHz
                clk_div <= 0;
                ADCclk_s <= not ADCclk_s;
            end if;
        end if;
    end process;    
        
    process(clk)
        begin
            if rising_edge(clk) then
                if enable = '1' then
                    case state is
                
                    when CH0 =>
                    
                        I1 <= '0'; I2 <= '0'; I3 <= '0'; -- Canal 0                       
                        state <= WAIT0;

                    when WAIT0 =>
                        if done = '1' then
                            dataN <= data_out;
                            state <= CH1;
                        end if;

                    when CH1 =>
                        I1 <= '1'; I2 <= '0'; I3 <= '0'; -- Canal 1 (001)
                        state <= WAIT1;

                    when WAIT1 =>
                        if done = '1' then
                            dataS <= data_out;
                            state <= CH2;
                        end if;

                    when CH2 =>
                        I1 <= '0'; I2 <= '1'; I3 <= '0'; -- Canal 2 (010)
                        state <= WAIT2;

                    when WAIT2 =>
                        if done = '1' then
                            dataE <= data_out;
                            state <= CH3;
                        end if;

                    when CH3 =>
                        I1 <= '1'; I2 <= '1'; I3 <= '0'; -- Canal 3 (011)
                        state <= WAIT3;

                    when WAIT3 =>
                        if done = '1' then
                            dataO <= data_out;
                            state <= CH0;  -- Ciclo infinito
                        end if;
                end case;
            else
                state <= CH0;
                I1 <= '0'; I2 <= '0'; I3 <= '0';
                dataN <= (others => '0');
                dataS <= (others => '0');
                dataE <= (others => '0');
                dataO <= (others => '0');
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
              if state = CH0 then  -- Cuando volvemos al primer canal
                if abs(to_integer(unsigned(dataN)) - to_integer(unsigned(dataS))) >= 1 then
                    comparacion(2) <= '1';
                    if unsigned(dataN) > unsigned(dataS) then
                        comparacion(0) <= '0';  -- N mayor que S
                    else
                        comparacion(0) <= '1';  -- S mayor que N
                    end if;
                else
                    comparacion(2) <= '0';
                end if;
                if abs(to_integer(unsigned(dataE)) - to_integer(unsigned(dataO))) >= 1 then
                comparacion(3) <= '1';
                    if unsigned(dataE) > unsigned(dataO) then
                        comparacion(1) <= '0';  -- E mayor que O
                    else
                        comparacion(1) <= '1';  --  mayor que N
                    end if;
                else
                    comparacion(3) <= '0';
                end if;
        end if;
    end if;
end process;

    process(clk)
        begin
            if rising_edge(clk) then
                refresh_counter <= refresh_counter + 1;
                display_select <= refresh_counter(15 downto 14);
            end if;
    end process;
    
    process(display_select, comparacion)
    begin
        case display_select is
            when "00" =>
                an <= "1110";  -- activa display 0
                if comparacion(0) = '0' then
                    seg <= seg_0;
                else
                    seg <= seg_1;
                end if;
            when "01" =>
                an <= "1101";  -- activa display 1
                if comparacion(1) = '0' then
                    seg <= seg_0;
                else
                    seg <= seg_1;
                end if;
            when "10" =>
                an <= "1011";  -- activa display 2
                if comparacion(2) = '0' then
                    seg <= seg_0;
                else
                    seg <= seg_1;
                end if;
            when others =>
                an <= "0111";  -- activa display 3
                if comparacion(3) = '0' then
                    seg <= seg_0;
                else
                    seg <= seg_1;
                end if;
        end case;
    end process;
    
  
    

end Behavioral;

