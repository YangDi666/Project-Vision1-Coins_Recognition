function varargout = projectGUI(varargin)
% PROJECTGUI MATLAB code for projectGUI.fig
%      PROJECTGUI, by itself, creates a new PROJECTGUI or raises the existing
%      singleton*.
%
%      H = PROJECTGUI returns the handle to a new PROJECTGUI or the handle to
%      the existing singleton*.
%
%      PROJECTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECTGUI.M with the given input arguments.
%
%      PROJECTGUI('Property','Value',...) creates a new PROJECTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projectGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projectGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help projectGUI

% Last Modified by GUIDE v2.5 24-Jan-2018 02:15:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @projectGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before projectGUI is made visible.
function projectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projectGUI (see VARARGIN)

% Choose default command line output for projectGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projectGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize variables and GUI items 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global myImage;
myImage = [];
global SF;
SF=0;
global wallet;
wallet=zeros(1,8);
global sum;
sum=0;
set(handles.edit1cent,'String','0');
set(handles.edit2cent,'String','0');
set(handles.edit5cent,'String','0');
set(handles.edit10cent,'String','0');
set(handles.edit20cent,'String','0');
set(handles.edit50cent,'String','0');
set(handles.edit1euro,'String','0');
set(handles.edit2euro,'String','0');
set(handles.editsum,'String','0');
set(handles.editSF,'String','0');
set(handles.axes1,'YTick',[]);
set(handles.axes1,'XTick',[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = projectGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonLoad.
function pushbuttonLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load image after clicking button 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FileName,PathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Select image files only!');
global myImage;
myImage = imread(fullfile(PathName,FileName));
axes(handles.axes1);
imshow(myImage);

set(handles.edit1cent,'String','0');
set(handles.edit2cent,'String','0');
set(handles.edit5cent,'String','0');
set(handles.edit10cent,'String','0');
set(handles.edit20cent,'String','0');
set(handles.edit50cent,'String','0');
set(handles.edit1euro,'String','0');
set(handles.edit2euro,'String','0');
set(handles.editsum,'String','0');
set(handles.editSF,'String','0');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on key press with focus on pushbuttonLoad and none of its controls.
function pushbuttonLoad_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoad (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonCalculate.
function pushbuttonCalculate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCalculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do processing calculation in loaded image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global myImage;
global wallet;
global sum;
global SF;
if(~isempty(myImage))
    if(SF~=0) 
        [wallet,sum,stats,result_detect]=coins_detect(myImage,SF);
        set(handles.edit1cent,'string',wallet(1,1));
        set(handles.edit2cent,'string',wallet(1,2));
        set(handles.edit5cent,'string',wallet(1,3));
        set(handles.edit10cent,'string',wallet(1,4));
        set(handles.edit20cent,'string',wallet(1,5)); 
        set(handles.edit50cent,'string',wallet(1,6));
        set(handles.edit1euro,'string',wallet(1,7));
        set(handles.edit2euro,'string',wallet(1,8)); 
        set(handles.editsum,'string',sum);
        set(handles.editSF,'String',SF);
        axes(handles.axes1);
        imshow(myImage);
        for i=1:size(stats,1)
            cent=round(stats(i).Centroid);
            switch result_detect(i)
                case 1
                    text(cent(1,1),cent(1,2),'C1','horiz','center','color','y') ;
                case 2
                    text(cent(1,1),cent(1,2),'C2','horiz','center','color','y') ;
                case 5
                    text(cent(1,1),cent(1,2),'C5','horiz','center','color','y') ;
                case 10
                    text(cent(1,1),cent(1,2),'C10','horiz','center','color','y') ;
                case 20
                    text(cent(1,1),cent(1,2),'C20','horiz','center','color','y') ;
                case 50
                    text(cent(1,1),cent(1,2),'C50','horiz','center','color','y') ;
                case 100
                    text(cent(1,1),cent(1,2),'E1','horiz','center','color','y') ;
                case 200
                    text(cent(1,1),cent(1,2),'E2','horiz','center','color','y') ;
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit1cent_Callback(hObject, eventdata, handles)
% hObject    handle to edit1cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1cent as text
%        str2double(get(hObject,'String')) returns contents of edit1cent as a double


% --- Executes during object creation, after setting all properties.
function edit1cent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2cent_Callback(hObject, eventdata, handles)
% hObject    handle to edit2cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2cent as text
%        str2double(get(hObject,'String')) returns contents of edit2cent as a double


% --- Executes during object creation, after setting all properties.
function edit2cent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5cent_Callback(hObject, eventdata, handles)
% hObject    handle to edit5cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5cent as text
%        str2double(get(hObject,'String')) returns contents of edit5cent as a double


% --- Executes during object creation, after setting all properties.
function edit5cent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonCalibrate.
function pushbuttonCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SF;
[out1]=Calibrate;
SF=out1;
set(handles.editSF,'string',SF);

function edit10cent_Callback(hObject, eventdata, handles)
% hObject    handle to edit10cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10cent as text
%        str2double(get(hObject,'String')) returns contents of edit10cent as a double


% --- Executes during object creation, after setting all properties.
function edit10cent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit20cent_Callback(hObject, eventdata, handles)
% hObject    handle to edit20cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20cent as text
%        str2double(get(hObject,'String')) returns contents of edit20cent as a double


% --- Executes during object creation, after setting all properties.
function edit20cent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit50cent_Callback(hObject, eventdata, handles)
% hObject    handle to edit50cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50cent as text
%        str2double(get(hObject,'String')) returns contents of edit50cent as a double


% --- Executes during object creation, after setting all properties.
function edit50cent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50cent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1euro_Callback(hObject, eventdata, handles)
% hObject    handle to edit1euro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1euro as text
%        str2double(get(hObject,'String')) returns contents of edit1euro as a double


% --- Executes during object creation, after setting all properties.
function edit1euro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1euro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2euro_Callback(hObject, eventdata, handles)
% hObject    handle to edit2euro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2euro as text
%        str2double(get(hObject,'String')) returns contents of edit2euro as a double


% --- Executes during object creation, after setting all properties.
function edit2euro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2euro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editsum_Callback(hObject, eventdata, handles)
% hObject    handle to editsum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editsum as text
%        str2double(get(hObject,'String')) returns contents of editsum as a double


% --- Executes during object creation, after setting all properties.
function editsum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editsum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSF_Callback(hObject, eventdata, handles)
% hObject    handle to editSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSF as text
%        str2double(get(hObject,'String')) returns contents of editSF as a double


% --- Executes during object creation, after setting all properties.
function editSF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonQuit.
function pushbuttonQuit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonQuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
