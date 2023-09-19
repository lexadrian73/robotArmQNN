function obj = connectRobot()
% connectRobot - Conecta el robot EV3

    try
        addpath('EV3\');
        obj = Brick('ioType', 'usb');
        obj.beep(5,500)
        disp('Conexion establecida');
    catch exception
        disp('El robot no está encendido o no está conectado.');
        disp(['Error: ' exception.message]);
        obj = [];
    end
end