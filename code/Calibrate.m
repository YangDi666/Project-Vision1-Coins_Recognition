function varargout = Calibrate(varargin)
% CALIBRATE MATLAB code for Calibrate.fig
%      CALIBRATE, by itself, creates a new CALIBRATE or raises the existing
%      singleton*.
%
%      H = CALIBRATE returns the handle to a new CALIBRATE or the handle to
%      the existing singleton*.
%
%      CALIBRATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATE.M with the given input arguments.
%
%      CALIBRATE('Property','Value',...) creates a new CALIBRATE or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calibrate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calibrate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calibrate

% Last Modified by GUIDE v2.5 24-Jan-2018 01:59:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calibrate_OpeningFcn, ...
                   'gui_OutputFcn',  @Calibrate_OutputFcn, ...
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

% --- Executes just before Calibrate is made visible.
function Calibrate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calibrate (see VARARGIN)

% Choose default command line output for Calibrate
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes Calibrate wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Calibrate_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.metricdata.SF;



% --- Executes during object creation, after setting all properties.
function SF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SF_Callback(hObject, eventdata, handles)
% hObject    handle to SF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SF as text
%        str2double(get(hObject,'String')) returns contents of SF as a double
SF = str2double(get(hObject, 'String'));
if isnan(SF)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new SF value
handles.metricdata.SF = SF;
guidata(hObject,handles)


% --- Executes on button press in pushbuttonReset.
function pushbuttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialize_gui(gcbf, handles, true);


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the pushbuttonReset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to pushbuttonReset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end
handles.metricdata.SF = 0;
set(handles.SF, 'String', handles.metricdata.SF);

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in pushbuttonSet.
function pushbuttonSet_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);



% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
