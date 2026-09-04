    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 14.06.2025 13:39:23
    -- Design Name: 
    -- Module Name: Top_Motores - Behavioral
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
    
    entity ControlMotores is
        Port (
            clk     : in  STD_LOGIC;       -- Reloj de 100MHz
            reset   : in  STD_LOGIC;       -- Reset (botón)
            sw_mover: in  STD_LOGIC;       -- Switch para habilitar movimiento
            sw_angle: in  STD_LOGIC;       -- Switch para ángulo (0=izq, 1=der)
            sw_mover1 : in  STD_LOGIC;       -- Switch para habilitar motor 2
            sw_angle1 : in  STD_LOGIC;       -- Switch para ángulo motor 2
            pwm     : out STD_LOGIC;       -- Salida PWM al motor
            pwm1     : out STD_LOGIC       -- Salida PWM al motor
             -- LEDs de estado
        );
    end ControlMotores;
    
    architecture Behavioral of ControlMotores is
        component Motor
            Port (
                clk     : in  STD_LOGIC;
                reset   : in  STD_LOGIC;
                mover   : in  STD_LOGIC;
                angle   : in  STD_LOGIC;
                pwm     : out STD_LOGIC
            );
        end component;
    begin
        
        motor_controller: Motor
        port map (
            clk     => clk,
            reset   => reset,
            mover   => sw_mover,
            angle   => sw_angle,
            pwm     => pwm
        );
        
        motor1_controller: Motor
        port map (
            clk     => clk,
            reset   => reset,
            mover   => sw_mover1,
            angle   => sw_angle1,
            pwm     => pwm1
        );
    end Behavioral;

