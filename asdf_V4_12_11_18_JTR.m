%% Light Relay Project: 
% Members: Jade Kuehn, Truong Duong, Richard Lopez
% Date: 12/11/2018
% Course: ENGR 114
% Objectives of code:
% * Display time, light on or off -
% * Plot time on vs days --
% * Replicate a natural cycle ---
%% Clear ,clc, close all
clear, clc, close all

%% Set up serial port and ensure it outputs data
Port = 'COM3';                  % !!! Port the Arduino is connected to !!!
delete(instrfindall);           % deletes any connected ports
a = serial(Port);              % create the serial port
fopen(a);                     % open the serial port
pause(1);                      % pause for 1 second to make sure a connection is made
out = instrfind ('Port ',Port) % see if the port you specified is open
disp ('Serial Port is Open')


%% Pulling out data
format short g
data_api = webread('https://api.thingspeak.com/channels/9/fields/1/last.json?timezone=America%2FLos_Angeles');
% datestr(datetime,'HH:MM')
data_to_table = struct2table(data_api);
data1 = data_to_table(:,1);

for i = data1
    % Day Timesplit()
    data_to_cell = table2array(data1);
    split_data = split(data_to_cell, '-');
    
    data2 = split_data(3,:);
    split_data1 = split(data2, 'T');
    data = split_data1(2,:);
    split_dat = split(data, ':');
    
    hr = split_dat (1,:);
    hr_mat = str2double(hr);
    
    min = split_dat(2,:);
    min_mat = str2double(min);
    
    sec = split_dat(3,:);
    sec_mat = str2double(sec);
end
%% EU Time
time_EU = [(hr_mat) min_mat sec_mat]
%hr_mat = 1
%% Ask User for Input and send input over serial

%% Read API for sunrise/sunset
format short g
data_api2 = webread('https://api.sunrise-sunset.org/json?lat=47.608013&lng=-122.335167&date=today');
data_to_table2 = struct2table(data_api2);

data2 = data_to_table2(:,1);
data3 = table2array(data2);
data4 = struct2cell(data3);
sunrise_T = data4(1);
sunset_T = data4(2);
day_length_T = data4(3);

%% Sunrise converted
data_to_cell = table2array(sunrise_T);
split_data2 = split(sunrise_T, ':');
sunrise_hr = split_data2 (1,:);

sunrise_hr_mat = str2double(sunrise_hr)-8;
    
if sunrise_hr_mat<0
    sunrise_hr_mat = 12 - abs(sunrise_hr_mat);
end
    
sunrise_min = split_data2(2,:);
sunrise_min_mat = str2double(sunrise_min);
    
    
sunrise_sec = split_data2(3,:);
sunrise_sec_str = cellstr(sunrise_sec);
sunrise_sec_1 = split(sunrise_sec_str);
sunrise_sec_mat = str2double(sunrise_sec_1(1));
   
time_sunrise = [sunrise_hr_mat sunrise_min_mat sunrise_sec_mat];
fprintf('The sun will rise at %d:%d:%d sec am \n "turn On\" lights', sunrise_hr_mat, sunrise_min_mat, sunrise_sec_mat)
    
%% Sunset converted
data_to_cell_set = table2array(sunset_T);
split_data3 = split(sunset_T, ':');
sunset_hr = split_data3(1,:);

sunset_hr_mat = str2double(sunset_hr)-8;
    
if sunset_hr_mat<0
    sunset_hr_mat = 12 - abs(sunset_hr_mat);
end
    
sunset_min = split_data3(2,:);
sunset_min_mat = str2double(sunset_min);
    

sunset_sec = split_data3(3,:);

sunset_sec_str = cellstr(sunset_sec);
sunset_sec_1 = split(sunset_sec_str);
sunset_sec_mat = str2double(sunset_sec_1(1));

time_sunset = [sunset_hr_mat sunset_min_mat sunset_sec_mat];
fprintf('\n The sun will set at %d:%d:%d sec pm \n "Turn Off\" lights', sunset_hr_mat, sunset_min_mat, sunset_sec_mat)


%% Day length converted
table2array(day_length_T);
split_data4 = split(day_length_T, ':');
day_length_hr = split_data4(1,:);

day_length_hr_mat = str2double(day_length_hr);

day_length_min = split_data4(2,:);
day_length_min_mat = str2double(day_length_min);
    
    
day_length_sec = split_data4(3,:);
day_length_sec_str = cellstr(day_length_sec);
day_length_sec_1 = split(day_length_sec_str);
day_length_sec_mat = str2double(day_length_sec_1(1));

time_day_length = [day_length_hr_mat day_length_min_mat day_length_sec_mat];
fprintf('\n The total amount of daylight for today will be %dhr %dmin %dsec\n ', day_length_hr_mat, day_length_min_mat, day_length_sec_mat)


%% Converting to minutes, day length

if day_length_sec_mat<=30
    day_length_sec_mat = 0;    
else
    day_length_sec_mat = 1;
end 
 
length_min = (day_length_hr_mat*60) + day_length_min_mat + day_length_sec_mat;

%% Then convert time to US time am/pm
sunset_EU_hr_mat = 12+sunset_hr_mat;
if (hr_mat>= sunrise_hr_mat && hr_mat<=sunset_EU_hr_mat) %hr_mat>=sunrise_hr_mat&& hr_mat<=sunset_hr_mat && min_mat>=sunrise_min_mat && min_mat<=sunset_min_mat & sec_mat>=sunrise_sec_mat & sec_mat<=sunset_sec_mat)
    fprintf('Now time is %d:%d:%d sec pm \n "turn On\" lights',hr_mat,min_mat,sec_mat)
    Light = 'Turn ON'
else
    fprintf('Now time is %d:%d:%dsec am \n "Turn Off\" lights',hr_mat,min_mat,sec_mat)
    Light = 'Turn OFF'
end


%% Plot %%%%%%%%%%%%%%%%%%%%%
%% Pulling out data
format short g
data_api = webread('https://api.thingspeak.com/channels/9/fields/1/last.json?timezone=America%2FLos_Angeles');
% datestr(datetime,'HH:MM')
data_to_table = struct2table(data_api);
data1 = data_to_table(:,1);
for i = data1
    data_to_cell = table2array(data1);
    split_data = split(data_to_cell, '-');
    data_table_url_1_data2 = split_data(3,:);


    Year_str = split_data(1);
    Year = str2double(Year_str);
    Year_char = char(Year_str);
    
    Month_str = split_data(2);
    Month = str2double(Month_str);
    Month_char = char(Month_str);
    
    data_table_url_1_data2 = split_data(3,:);
    split_data1 = split(data_table_url_1_data2, 'T');
    Day_str = split_data1(1);
    
    Day = str2double(Day_str);
    Day_char = char(Day_str);
    
   
end


%% 20 if statements
link = ['https://api.sunrise-sunset.org/json?lat=47.608013&lng=-122.335167&date='];
cn = char('-');
%url = [ link, Year_char,  cn Month_char  cn Day_char ]
%webread(url)

if (Month==1 | Month ==3 | Month==5 | Month==7 | Month==8 | Month==10 | Month==12) 
    %Month  = 
    D = 1:31;   % Days in the month 
    D_str = num2str(D);
    D_char = char(D_str);
    
%%%
    url_1 = [ link, Year_char,  cn, Month_char,  cn D_char(1) ];
    web_1 = webread(url_1);
    
    data_table_url_1 = struct2table(web_1);

    data_table_url_1_data2 = data_table_url_1(:,1);
    data_table_url_1_data3 = table2array(data_table_url_1_data2);
    data_table_url_1_data4 = struct2cell(data_table_url_1_data3);

    day_length_T_url_1 = data_table_url_1_data4(3);

    table2array(day_length_T_url_1);
    url_1_split_data4 = split(day_length_T_url_1, ':');
    url_1_day_length_hr = url_1_split_data4(1,:);

    url_1_day_length_hr_mat = str2double(url_1_day_length_hr);

    url_1_day_length_min = url_1_split_data4(2,:);
    url_1_day_length_min_mat = str2double(url_1_day_length_min);
    
    
    url_1_day_length_sec = url_1_split_data4(3,:);
    url_1_day_length_sec_str = cellstr(url_1_day_length_sec);
    url_1_day_length_sec_1 = split(url_1_day_length_sec_str);
    url_1_day_length_sec_mat = str2double(url_1_day_length_sec_1(1));
    url_1_total_time_1 = url_1_day_length_hr_mat*60 + url_1_day_length_min_mat + url_1_day_length_sec_mat/60;
%%%
    url_2 = [ link, Year_char,  cn, Month_char,  cn, D_char(5) ];
    web_2 = webread(url_2);

    data_table_url_2 = struct2table(web_2);

    data_table_url_2_data2 = data_table_url_2(:,1);
    data_table_url_2_data3 = table2array(data_table_url_2_data2);
    data_table_url_2_data4 = struct2cell(data_table_url_2_data3);

    day_length_T_url_2 = data_table_url_2_data4(3);

    table2array(day_length_T_url_2);
    url_2_split_data4 = split(day_length_T_url_2, ':');
    url_2_day_length_hr = url_2_split_data4(1,:);

    url_2_day_length_hr_mat = str2double(url_2_day_length_hr);

    url_2_day_length_min = url_2_split_data4(2,:);
    url_2_day_length_min_mat = str2double(url_2_day_length_min);
    
    
    url_2_day_length_sec = url_2_split_data4(3,:);
    url_2_day_length_sec_str = cellstr(url_2_day_length_sec);
    url_2_day_length_sec_1 = split(url_2_day_length_sec_str);
    url_2_day_length_sec_mat = str2double(url_2_day_length_sec_1(1));
    url_2_total_time_1 = url_2_day_length_hr_mat*60 + url_2_day_length_min_mat + url_2_day_length_sec_mat/60;
%%%
    
    
    
    url_3 = [ link, Year_char,  cn, Month_char,  cn, D_char(9) ];
    web_3 = webread(url_3);
    
    data_table_url_3 = struct2table(web_3);

    data_table_url_3_data2 = data_table_url_3(:,1);
    data_table_url_3_data3 = table2array(data_table_url_3_data2);
    data_table_url_3_data4 = struct2cell(data_table_url_3_data3);

    day_length_T_url_3 = data_table_url_3_data4(3);

    table2array(day_length_T_url_3);
    url_3_split_data4 = split(day_length_T_url_3, ':');
    url_3_day_length_hr = url_3_split_data4(1,:);

    url_3_day_length_hr_mat = str2double(url_3_day_length_hr);

    url_3_day_length_min = url_3_split_data4(2,:);
    url_3_day_length_min_mat = str2double(url_3_day_length_min);
    
    
    url_3_day_length_sec = url_3_split_data4(3,:);
    url_3_day_length_sec_str = cellstr(url_3_day_length_sec);
    url_3_day_length_sec_1 = split(url_3_day_length_sec_str);
    url_3_day_length_sec_mat = str2double(url_3_day_length_sec_1(1));
    url_3_total_time_1 = url_3_day_length_hr_mat*60 + url_3_day_length_min_mat + url_3_day_length_sec_mat/60;
    

    url_4 = [ link, Year_char,  cn, Month_char,  cn, D_char(13) ];
    web_4 =  webread(url_4);
    
    data_table_url_4 = struct2table(web_4);
    data_table_url_4_data2 = data_table_url_4(:,1);
    data_table_url_4_data3 = table2array(data_table_url_4_data2);
    data_table_url_4_data4 = struct2cell(data_table_url_4_data3);
    day_length_T_url_4 = data_table_url_4_data4(3);

    table2array(day_length_T_url_4);
    url_4_split_data4 = split(day_length_T_url_4, ':');
    url_4_day_length_hr = url_4_split_data4(1,:);

    url_4_day_length_hr_mat = str2double(url_4_day_length_hr);

    url_4_day_length_min = url_4_split_data4(2,:);
    url_4_day_length_min_mat = str2double(url_4_day_length_min);
    
    
    url_4_day_length_sec = url_4_split_data4(3,:);
    url_4_day_length_sec_str = cellstr(url_4_day_length_sec);
    url_4_day_length_sec_1 = split(url_4_day_length_sec_str);
    url_4_day_length_sec_mat = str2double(url_4_day_length_sec_1(1));
    url_4_total_time_1 = url_4_day_length_hr_mat*60 + url_4_day_length_min_mat + url_4_day_length_sec_mat/60;
    

    
    url_5 = [ link, Year_char,  cn, Month_char,  cn, D_char(17) ];
    web_5 = webread(url_5);
    
    
    data_table_url_5 = struct2table(web_5);

    data_table_url_5_data2 = data_table_url_5(:,1);
    data_table_url_5_data3 = table2array(data_table_url_5_data2);
    data_table_url_5_data4 = struct2cell(data_table_url_5_data3);

    day_length_T_url_5 = data_table_url_5_data4(3);

    table2array(day_length_T_url_5);
    url_5_split_data4 = split(day_length_T_url_5, ':');
    url_5_day_length_hr = url_5_split_data4(1,:);

    url_5_day_length_hr_mat = str2double(url_5_day_length_hr);

    url_5_day_length_min = url_5_split_data4(2,:);
    url_5_day_length_min_mat = str2double(url_5_day_length_min);
    
    
    url_5_day_length_sec = url_5_split_data4(3,:);
    url_5_day_length_sec_str = cellstr(url_5_day_length_sec);
    url_5_day_length_sec_1 = split(url_5_day_length_sec_str);
    url_5_day_length_sec_mat = str2double(url_5_day_length_sec_1(1));
    url_5_total_time_1 = url_5_day_length_hr_mat*60 + url_5_day_length_min_mat + url_5_day_length_sec_mat/60;
    
    
    
    
    url_6 = [ link, Year_char,  cn, Month_char,  cn, D_char(21) ];
    web_6 = webread(url_6);
    
    data_table_url_6 = struct2table(web_6);

    data_table_url_6_data2 = data_table_url_6(:,1);
    data_table_url_6_data3 = table2array(data_table_url_6_data2);
    data_table_url_6_data4 = struct2cell(data_table_url_6_data3);

    day_length_T_url_6 = data_table_url_6_data4(3);

    table2array(day_length_T_url_6);
    url_6_split_data4 = split(day_length_T_url_6, ':');
    url_6_day_length_hr = url_6_split_data4(1,:);

    url_6_day_length_hr_mat = str2double(url_6_day_length_hr);

    url_6_day_length_min = url_6_split_data4(2,:);
    url_6_day_length_min_mat = str2double(url_6_day_length_min);
    
    
    url_6_day_length_sec = url_6_split_data4(3,:);
    url_6_day_length_sec_str = cellstr(url_6_day_length_sec);
    url_6_day_length_sec_1 = split(url_6_day_length_sec_str);
    url_6_day_length_sec_mat = str2double(url_6_day_length_sec_1(1));
    url_6_total_time_1 = url_6_day_length_hr_mat*60 + url_6_day_length_min_mat + url_6_day_length_sec_mat/60;
    
    
    
    url_7 = [ link, Year_char,  cn, Month_char,  cn, D_char(25) ];
    web_7 = webread(url_7);
     
    data_table_url_7 = struct2table(web_7);

    data_table_url_7_data2 = data_table_url_7(:,1);
    data_table_url_7_data3 = table2array(data_table_url_7_data2);
    data_table_url_7_data4 = struct2cell(data_table_url_7_data3);

    day_length_T_url_7 = data_table_url_7_data4(3);

    table2array(day_length_T_url_7);
    url_7_split_data4 = split(day_length_T_url_7, ':');
    url_7_day_length_hr = url_7_split_data4(1,:);

    url_7_day_length_hr_mat = str2double(url_7_day_length_hr);

    url_7_day_length_min = url_7_split_data4(2,:);
    url_7_day_length_min_mat = str2double(url_7_day_length_min);
    
    
    url_7_day_length_sec = url_7_split_data4(3,:);
    url_7_day_length_sec_str = cellstr(url_7_day_length_sec);
    url_7_day_length_sec_1 = split(url_7_day_length_sec_str);
    url_7_day_length_sec_mat = str2double(url_7_day_length_sec_1(1));
    url_7_total_time_1 = url_7_day_length_hr_mat*60 + url_7_day_length_min_mat + url_7_day_length_sec_mat/60;
    
    url_8 = [ link, Year_char,  cn, Month_char,  cn, D_char(29) ];
    web_8 = webread(url_8);
    
    data_table_url_8 = struct2table(web_8);

    data_table_url_8_data2 = data_table_url_8(:,1);
    data_table_url_8_data3 = table2array(data_table_url_8_data2);
    data_table_url_8_data4 = struct2cell(data_table_url_8_data3);

    day_length_T_url_8 = data_table_url_8_data4(3);

    table2array(day_length_T_url_8);
    url_8_split_data4 = split(day_length_T_url_8, ':');
    url_8_day_length_hr = url_8_split_data4(1,:);

    url_8_day_length_hr_mat = str2double(url_8_day_length_hr);

    url_8_day_length_min = url_8_split_data4(2,:);
    url_8_day_length_min_mat = str2double(url_8_day_length_min);
    
    
    url_8_day_length_sec = url_8_split_data4(3,:);
    url_8_day_length_sec_str = cellstr(url_8_day_length_sec);
    url_8_day_length_sec_1 = split(url_8_day_length_sec_str);
    url_8_day_length_sec_mat = str2double(url_8_day_length_sec_1(1));
    url_8_total_time_1 = url_8_day_length_hr_mat*60 + url_8_day_length_min_mat + url_8_day_length_sec_mat/60;
    
    
    url_9 = [ link, Year_char,  cn, Month_char,  cn, D_char(33) ];
    web_9 = webread(url_9);
    
     data_table_url_9 = struct2table(web_9);

    data_table_url_9_data2 = data_table_url_9(:,1);
    data_table_url_9_data3 = table2array(data_table_url_9_data2);
    data_table_url_9_data4 = struct2cell(data_table_url_9_data3);

    day_length_T_url_9 = data_table_url_9_data4(3);

    table2array(day_length_T_url_9);
    url_9_split_data4 = split(day_length_T_url_9, ':');
    url_9_day_length_hr = url_9_split_data4(1,:);

    url_9_day_length_hr_mat = str2double(url_9_day_length_hr);

    url_9_day_length_min = url_9_split_data4(2,:);
    url_9_day_length_min_mat = str2double(url_9_day_length_min);
    
    
    url_9_day_length_sec = url_9_split_data4(3,:);
    url_9_day_length_sec_str = cellstr(url_9_day_length_sec);
    url_9_day_length_sec_1 = split(url_9_day_length_sec_str);
    url_9_day_length_sec_mat = str2double(url_9_day_length_sec_1(1));
    url_9_total_time_1 = url_9_day_length_hr_mat*60 + url_9_day_length_min_mat + url_9_day_length_sec_mat/60;
    
    url_10 = [ link, Year_char,  cn, Month_char,  cn, D_char(36:37) ];
    web_10 = webread(url_10);
    
     data_table_url_10 = struct2table(web_10);

    data_table_url_10_data2 = data_table_url_10(:,1);
    data_table_url_10_data3 = table2array(data_table_url_10_data2);
    data_table_url_10_data4 = struct2cell(data_table_url_10_data3);

    day_length_T_url_10 = data_table_url_10_data4(3);

    table2array(day_length_T_url_10);
    url_10_split_data4 = split(day_length_T_url_10, ':');
    url_10_day_length_hr = url_10_split_data4(1,:);

    url_10_day_length_hr_mat = str2double(url_10_day_length_hr);

    url_10_day_length_min = url_10_split_data4(2,:);
    url_10_day_length_min_mat = str2double(url_10_day_length_min);
    
    
    url_10_day_length_sec = url_10_split_data4(3,:);
    url_10_day_length_sec_str = cellstr(url_10_day_length_sec);
    url_10_day_length_sec_1 = split(url_10_day_length_sec_str);
    url_10_day_length_sec_mat = str2double(url_10_day_length_sec_1(1));
    url_10_total_time_1 = url_10_day_length_hr_mat*60 + url_10_day_length_min_mat + url_10_day_length_sec_mat/60;
    
    
    url_11 = [ link, Year_char,  cn, Month_char,  cn, D_char(40:41) ];
    web_11 =  webread(url_11);
    
     data_table_url_11 = struct2table(web_11);

    data_table_url_11_data2 = data_table_url_11(:,1);
    data_table_url_11_data3 = table2array(data_table_url_11_data2);
    data_table_url_11_data4 = struct2cell(data_table_url_11_data3);

    day_length_T_url_11 = data_table_url_11_data4(3);

    table2array(day_length_T_url_11);
    url_11_split_data4 = split(day_length_T_url_11, ':');
    url_11_day_length_hr = url_11_split_data4(1,:);

    url_11_day_length_hr_mat = str2double(url_11_day_length_hr);

    url_11_day_length_min = url_11_split_data4(2,:);
    url_11_day_length_min_mat = str2double(url_11_day_length_min);
    
    
    url_11_day_length_sec = url_11_split_data4(3,:);
    url_11_day_length_sec_str = cellstr(url_11_day_length_sec);
    url_11_day_length_sec_1 = split(url_11_day_length_sec_str);
    url_11_day_length_sec_mat = str2double(url_11_day_length_sec_1(1));
    url_11_total_time_1 = url_11_day_length_hr_mat*60 + url_11_day_length_min_mat + url_11_day_length_sec_mat/60;
    
    
    url_12 = [ link, Year_char,  cn, Month_char,  cn, D_char(44:45) ];
    web_12 =  webread(url_12);
     
    data_table_url_12 = struct2table(web_12);

    data_table_url_12_data2 = data_table_url_12(:,1);
    data_table_url_12_data3 = table2array(data_table_url_12_data2);
    data_table_url_12_data4 = struct2cell(data_table_url_12_data3);

    day_length_T_url_12 = data_table_url_12_data4(3);

    table2array(day_length_T_url_12);
    url_12_split_data4 = split(day_length_T_url_12, ':');
    url_12_day_length_hr = url_12_split_data4(1,:);

    url_12_day_length_hr_mat = str2double(url_12_day_length_hr);

    url_12_day_length_min = url_12_split_data4(2,:);
    url_12_day_length_min_mat = str2double(url_12_day_length_min);
    
    
    url_12_day_length_sec = url_12_split_data4(3,:);
    url_12_day_length_sec_str = cellstr(url_12_day_length_sec);
    url_12_day_length_sec_1 = split(url_12_day_length_sec_str);
    url_12_day_length_sec_mat = str2double(url_12_day_length_sec_1(1));
    url_12_total_time_1 = url_12_day_length_hr_mat*60 + url_12_day_length_min_mat + url_12_day_length_sec_mat/60;
    
    
    url_13 = [ link, Year_char,  cn, Month_char,  cn, D_char(48:49) ];
    web_13 = webread(url_13);
    
     data_table_url_13 = struct2table(web_13);

    data_table_url_13_data2 = data_table_url_13(:,1);
    data_table_url_13_data3 = table2array(data_table_url_13_data2);
    data_table_url_13_data4 = struct2cell(data_table_url_13_data3);

    day_length_T_url_13 = data_table_url_13_data4(3);

    table2array(day_length_T_url_13);
    url_13_split_data4 = split(day_length_T_url_13, ':');
    url_13_day_length_hr = url_13_split_data4(1,:);

    url_13_day_length_hr_mat = str2double(url_13_day_length_hr);

    url_13_day_length_min = url_13_split_data4(2,:);
    url_13_day_length_min_mat = str2double(url_13_day_length_min);
    
    
    url_13_day_length_sec = url_13_split_data4(3,:);
    url_13_day_length_sec_str = cellstr(url_13_day_length_sec);
    url_13_day_length_sec_1 = split(url_13_day_length_sec_str);
    url_13_day_length_sec_mat = str2double(url_13_day_length_sec_1(1));
    url_13_total_time_1 = url_13_day_length_hr_mat*60 + url_13_day_length_min_mat + url_13_day_length_sec_mat/60;
    
    url_14 = [ link, Year_char,  cn, Month_char,  cn, D_char(52:53) ];
    web_14  = webread(url_14);
    
    data_table_url_14 = struct2table(web_14);

    data_table_url_14_data2 = data_table_url_14(:,1);
    data_table_url_14_data3 = table2array(data_table_url_14_data2);
    data_table_url_14_data4 = struct2cell(data_table_url_14_data3);

    day_length_T_url_14 = data_table_url_14_data4(3);

    table2array(day_length_T_url_14);
    url_14_split_data4 = split(day_length_T_url_14, ':');
    url_14_day_length_hr = url_14_split_data4(1,:);

    url_14_day_length_hr_mat = str2double(url_14_day_length_hr);

    url_14_day_length_min = url_14_split_data4(2,:);
    url_14_day_length_min_mat = str2double(url_14_day_length_min);
    
    
    url_14_day_length_sec = url_14_split_data4(3,:);
    url_14_day_length_sec_str = cellstr(url_14_day_length_sec);
    url_14_day_length_sec_1 = split(url_14_day_length_sec_str);
    url_14_day_length_sec_mat = str2double(url_14_day_length_sec_1(1));
    url_14_total_time_1 = url_14_day_length_hr_mat*60 + url_14_day_length_min_mat + url_14_day_length_sec_mat/60;
    
    
    
    url_15 = [ link, Year_char,  cn, Month_char,  cn, D_char(56:57) ];
    web_15 = webread(url_15);
    data_table_url_15 = struct2table(web_15);

    data_table_url_15_data2 = data_table_url_15(:,1);
    data_table_url_15_data3 = table2array(data_table_url_15_data2);
    data_table_url_15_data4 = struct2cell(data_table_url_15_data3);

    day_length_T_url_15 = data_table_url_15_data4(3);

    table2array(day_length_T_url_15);
    url_15_split_data4 = split(day_length_T_url_15, ':');
    url_15_day_length_hr = url_15_split_data4(1,:);

    url_15_day_length_hr_mat = str2double(url_15_day_length_hr);

    url_15_day_length_min = url_15_split_data4(2,:);
    url_15_day_length_min_mat = str2double(url_15_day_length_min);
    
    
    url_15_day_length_sec = url_15_split_data4(3,:);
    url_15_day_length_sec_str = cellstr(url_15_day_length_sec);
    url_15_day_length_sec_1 = split(url_15_day_length_sec_str);
    url_15_day_length_sec_mat = str2double(url_15_day_length_sec_1(1));
    url_15_total_time_1 = url_15_day_length_hr_mat*60 + url_15_day_length_min_mat + url_15_day_length_sec_mat/60;

    url_16 = [ link, Year_char,  cn, Month_char,  cn, D_char(60:61) ];
    web_16 = webread(url_16);
    data_table_url_16 = struct2table(web_16);

    data_table_url_16_data2 = data_table_url_16(:,1);
    data_table_url_16_data3 = table2array(data_table_url_16_data2);
    data_table_url_16_data4 = struct2cell(data_table_url_16_data3);

    day_length_T_url_16 = data_table_url_16_data4(3);

    table2array(day_length_T_url_16);
    url_16_split_data4 = split(day_length_T_url_16, ':');
    url_16_day_length_hr = url_16_split_data4(1,:);

    url_16_day_length_hr_mat = str2double(url_16_day_length_hr);

    url_16_day_length_min = url_16_split_data4(2,:);
    url_16_day_length_min_mat = str2double(url_16_day_length_min);
    
    
    url_16_day_length_sec = url_16_split_data4(3,:);
    url_16_day_length_sec_str = cellstr(url_16_day_length_sec);
    url_16_day_length_sec_1 = split(url_16_day_length_sec_str);
    url_16_day_length_sec_mat = str2double(url_16_day_length_sec_1(1));
    url_16_total_time_1 = url_16_day_length_hr_mat*60 + url_16_day_length_min_mat + url_16_day_length_sec_mat/60;

    url_17 = [ link, Year_char,  cn, Month_char,  cn, D_char(64:65) ];
    web_17 = webread(url_17);
    data_table_url_17 = struct2table(web_17);

    data_table_url_17_data2 = data_table_url_17(:,1);
    data_table_url_17_data3 = table2array(data_table_url_17_data2);
    data_table_url_17_data4 = struct2cell(data_table_url_17_data3);

    day_length_T_url_17 = data_table_url_17_data4(3);

    table2array(day_length_T_url_17);
    url_17_split_data4 = split(day_length_T_url_17, ':');
    url_17_day_length_hr = url_17_split_data4(1,:);

    url_17_day_length_hr_mat = str2double(url_17_day_length_hr);

    url_17_day_length_min = url_17_split_data4(2,:);
    url_17_day_length_min_mat = str2double(url_17_day_length_min);
    
    
    url_17_day_length_sec = url_17_split_data4(3,:);
    url_17_day_length_sec_str = cellstr(url_17_day_length_sec);
    url_17_day_length_sec_1 = split(url_17_day_length_sec_str);
    url_17_day_length_sec_mat = str2double(url_17_day_length_sec_1(1));
    url_17_total_time_1 = url_17_day_length_hr_mat*60 + url_17_day_length_min_mat + url_17_day_length_sec_mat/60;

    url_18 = [ link, Year_char,  cn, Month_char,  cn, D_char(68:69) ];
    web_18 = webread(url_18);
    data_table_url_18 = struct2table(web_18);

    data_table_url_18_data2 = data_table_url_18(:,1);
    data_table_url_18_data3 = table2array(data_table_url_18_data2);
    data_table_url_18_data4 = struct2cell(data_table_url_18_data3);

    day_length_T_url_18 = data_table_url_18_data4(3);

    table2array(day_length_T_url_18);
    url_18_split_data4 = split(day_length_T_url_18, ':');
    url_18_day_length_hr = url_18_split_data4(1,:);

    url_18_day_length_hr_mat = str2double(url_18_day_length_hr);

    url_18_day_length_min = url_18_split_data4(2,:);
    url_18_day_length_min_mat = str2double(url_18_day_length_min);
    
    
    url_18_day_length_sec = url_18_split_data4(3,:);
    url_18_day_length_sec_str = cellstr(url_18_day_length_sec);
    url_18_day_length_sec_1 = split(url_18_day_length_sec_str);
    url_18_day_length_sec_mat = str2double(url_18_day_length_sec_1(1));
    url_18_total_time_1 = url_18_day_length_hr_mat*60 + url_18_day_length_min_mat + url_18_day_length_sec_mat/60;

    url_19 = [ link, Year_char,  cn, Month_char,  cn, D_char(72:73) ];
    web_19 = webread(url_19);
    data_table_url_19 = struct2table(web_19);

    data_table_url_19_data2 = data_table_url_19(:,1);
    data_table_url_19_data3 = table2array(data_table_url_19_data2);
    data_table_url_19_data4 = struct2cell(data_table_url_19_data3);

    day_length_T_url_19 = data_table_url_19_data4(3);

    table2array(day_length_T_url_19);
    url_19_split_data4 = split(day_length_T_url_19, ':');
    url_19_day_length_hr = url_19_split_data4(1,:);

    url_19_day_length_hr_mat = str2double(url_19_day_length_hr);

    url_19_day_length_min = url_19_split_data4(2,:);
    url_19_day_length_min_mat = str2double(url_19_day_length_min);
    
    
    url_19_day_length_sec = url_19_split_data4(3,:);
    url_19_day_length_sec_str = cellstr(url_19_day_length_sec);
    url_19_day_length_sec_1 = split(url_19_day_length_sec_str);
    url_19_day_length_sec_mat = str2double(url_19_day_length_sec_1(1));
    url_19_total_time_1 = url_19_day_length_hr_mat*60 + url_19_day_length_min_mat + url_19_day_length_sec_mat/60;

    url_20 = [ link, Year_char,  cn, Month_char,  cn, D_char(76:77) ];
    web_20 = webread(url_20);
    data_table_url_20 = struct2table(web_20);

    data_table_url_20_data2 = data_table_url_20(:,1);
    data_table_url_20_data3 = table2array(data_table_url_20_data2);
    data_table_url_20_data4 = struct2cell(data_table_url_20_data3);

    day_length_T_url_20 = data_table_url_20_data4(3);

    table2array(day_length_T_url_20);
    url_20_split_data4 = split(day_length_T_url_20, ':');
    url_20_day_length_hr = url_20_split_data4(1,:);

    url_20_day_length_hr_mat = str2double(url_20_day_length_hr);

    url_20_day_length_min = url_20_split_data4(2,:);
    url_20_day_length_min_mat = str2double(url_20_day_length_min);
    
    
    url_20_day_length_sec = url_20_split_data4(3,:);
    url_20_day_length_sec_str = cellstr(url_20_day_length_sec);
    url_20_day_length_sec_1 = split(url_20_day_length_sec_str);
    url_20_day_length_sec_mat = str2double(url_20_day_length_sec_1(1));
    url_20_total_time_1 = url_20_day_length_hr_mat*60 + url_20_day_length_min_mat + url_20_day_length_sec_mat/60;

    url_21 = [ link, Year_char,  cn, Month_char,  cn, D_char(80:81) ];
    web_21 = webread(url_21);
    data_table_url_21 = struct2table(web_21);

    data_table_url_21_data2 = data_table_url_21(:,1);
    data_table_url_21_data3 = table2array(data_table_url_21_data2);
    data_table_url_21_data4 = struct2cell(data_table_url_21_data3);

    day_length_T_url_21 = data_table_url_21_data4(3);

    table2array(day_length_T_url_21);
    url_21_split_data4 = split(day_length_T_url_21, ':');
    url_21_day_length_hr = url_21_split_data4(1,:);

    url_21_day_length_hr_mat = str2double(url_21_day_length_hr);

    url_21_day_length_min = url_21_split_data4(2,:);
    url_21_day_length_min_mat = str2double(url_21_day_length_min);
    
    
    url_21_day_length_sec = url_21_split_data4(3,:);
    url_21_day_length_sec_str = cellstr(url_21_day_length_sec);
    url_21_day_length_sec_1 = split(url_21_day_length_sec_str);
    url_21_day_length_sec_mat = str2double(url_21_day_length_sec_1(1));
    url_21_total_time_1 = url_21_day_length_hr_mat*60 + url_21_day_length_min_mat + url_21_day_length_sec_mat/60;

    url_22 = [ link, Year_char,  cn, Month_char,  cn, D_char(84:85) ];
    web_22 = webread(url_22);
    data_table_url_22 = struct2table(web_22);

    data_table_url_22_data2 = data_table_url_22(:,1);
    data_table_url_22_data3 = table2array(data_table_url_22_data2);
    data_table_url_22_data4 = struct2cell(data_table_url_22_data3);

    day_length_T_url_22 = data_table_url_22_data4(3);

    table2array(day_length_T_url_22);
    url_22_split_data4 = split(day_length_T_url_22, ':');
    url_22_day_length_hr = url_22_split_data4(1,:);

    url_22_day_length_hr_mat = str2double(url_22_day_length_hr);

    url_22_day_length_min = url_22_split_data4(2,:);
    url_22_day_length_min_mat = str2double(url_22_day_length_min);
    
    
    url_22_day_length_sec = url_22_split_data4(3,:);
    url_22_day_length_sec_str = cellstr(url_22_day_length_sec);
    url_22_day_length_sec_1 = split(url_22_day_length_sec_str);
    url_22_day_length_sec_mat = str2double(url_22_day_length_sec_1(1));
    url_22_total_time_1 = url_22_day_length_hr_mat*60 + url_22_day_length_min_mat + url_22_day_length_sec_mat/60;

    url_23 = [ link, Year_char,  cn, Month_char,  cn, D_char(88:89) ];
    web_23 = webread(url_23);
    data_table_url_23 = struct2table(web_23);

    data_table_url_23_data2 = data_table_url_23(:,1);
    data_table_url_23_data3 = table2array(data_table_url_23_data2);
    data_table_url_23_data4 = struct2cell(data_table_url_23_data3);

    day_length_T_url_23 = data_table_url_23_data4(3);

    table2array(day_length_T_url_23);
    url_23_split_data4 = split(day_length_T_url_23, ':');
    url_23_day_length_hr = url_23_split_data4(1,:);

    url_23_day_length_hr_mat = str2double(url_23_day_length_hr);

    url_23_day_length_min = url_23_split_data4(2,:);
    url_23_day_length_min_mat = str2double(url_23_day_length_min);
    
    
    url_23_day_length_sec = url_23_split_data4(3,:);
    url_23_day_length_sec_str = cellstr(url_23_day_length_sec);
    url_23_day_length_sec_1 = split(url_23_day_length_sec_str);
    url_23_day_length_sec_mat = str2double(url_23_day_length_sec_1(1));
    url_23_total_time_1 = url_23_day_length_hr_mat*60 + url_23_day_length_min_mat + url_23_day_length_sec_mat/60;

    url_24 = [ link, Year_char,  cn, Month_char,  cn, D_char(92:93) ];
    web_24 = webread(url_24);
    data_table_url_24 = struct2table(web_24);

    data_table_url_24_data2 = data_table_url_24(:,1);
    data_table_url_24_data3 = table2array(data_table_url_24_data2);
    data_table_url_24_data4 = struct2cell(data_table_url_24_data3);

    day_length_T_url_24 = data_table_url_24_data4(3);

    table2array(day_length_T_url_24);
    url_24_split_data4 = split(day_length_T_url_24, ':');
    url_24_day_length_hr = url_24_split_data4(1,:);

    url_24_day_length_hr_mat = str2double(url_24_day_length_hr);

    url_24_day_length_min = url_24_split_data4(2,:);
    url_24_day_length_min_mat = str2double(url_24_day_length_min);
    
    
    url_24_day_length_sec = url_24_split_data4(3,:);
    url_24_day_length_sec_str = cellstr(url_24_day_length_sec);
    url_24_day_length_sec_1 = split(url_24_day_length_sec_str);
    url_24_day_length_sec_mat = str2double(url_24_day_length_sec_1(1));
    url_24_total_time_1 = url_24_day_length_hr_mat*60 + url_24_day_length_min_mat + url_24_day_length_sec_mat/60;

    url_25 = [ link, Year_char,  cn, Month_char,  cn, D_char(96:97) ];
    web_25 = webread(url_25);
    data_table_url_25 = struct2table(web_25);

    data_table_url_25_data2 = data_table_url_25(:,1);
    data_table_url_25_data3 = table2array(data_table_url_25_data2);
    data_table_url_25_data4 = struct2cell(data_table_url_25_data3);

    day_length_T_url_25 = data_table_url_25_data4(3);

    table2array(day_length_T_url_25);
    url_25_split_data4 = split(day_length_T_url_25, ':');
    url_25_day_length_hr = url_25_split_data4(1,:);

    url_25_day_length_hr_mat = str2double(url_25_day_length_hr);

    url_25_day_length_min = url_25_split_data4(2,:);
    url_25_day_length_min_mat = str2double(url_25_day_length_min);
    
    
    url_25_day_length_sec = url_25_split_data4(3,:);
    url_25_day_length_sec_str = cellstr(url_25_day_length_sec);
    url_25_day_length_sec_1 = split(url_25_day_length_sec_str);
    url_25_day_length_sec_mat = str2double(url_25_day_length_sec_1(1));
    url_25_total_time_1 = url_25_day_length_hr_mat*60 + url_25_day_length_min_mat + url_25_day_length_sec_mat/60;

    url_26 = [ link, Year_char,  cn, Month_char,  cn, D_char(100:101) ];
    web_26 = webread(url_26);
    data_table_url_26 = struct2table(web_26);

    data_table_url_26_data2 = data_table_url_26(:,1);
    data_table_url_26_data3 = table2array(data_table_url_26_data2);
    data_table_url_26_data4 = struct2cell(data_table_url_26_data3);

    day_length_T_url_26 = data_table_url_26_data4(3);

    table2array(day_length_T_url_26);
    url_26_split_data4 = split(day_length_T_url_26, ':');
    url_26_day_length_hr = url_26_split_data4(1,:);

    url_26_day_length_hr_mat = str2double(url_26_day_length_hr);

    url_26_day_length_min = url_26_split_data4(2,:);
    url_26_day_length_min_mat = str2double(url_26_day_length_min);
    
    
    url_26_day_length_sec = url_26_split_data4(3,:);
    url_26_day_length_sec_str = cellstr(url_26_day_length_sec);
    url_26_day_length_sec_1 = split(url_26_day_length_sec_str);
    url_26_day_length_sec_mat = str2double(url_26_day_length_sec_1(1));
    url_26_total_time_1 = url_26_day_length_hr_mat*60 + url_26_day_length_min_mat + url_26_day_length_sec_mat/60;

    url_27 = [ link, Year_char,  cn, Month_char,  cn, D_char(104:105) ];
    web_27 = webread(url_27);
    data_table_url_27 = struct2table(web_27);

    data_table_url_27_data2 = data_table_url_27(:,1);
    data_table_url_27_data3 = table2array(data_table_url_27_data2);
    data_table_url_27_data4 = struct2cell(data_table_url_27_data3);

    day_length_T_url_27 = data_table_url_27_data4(3);

    table2array(day_length_T_url_27);
    url_27_split_data4 = split(day_length_T_url_27, ':');
    url_27_day_length_hr = url_27_split_data4(1,:);

    url_27_day_length_hr_mat = str2double(url_27_day_length_hr);

    url_27_day_length_min = url_27_split_data4(2,:);
    url_27_day_length_min_mat = str2double(url_27_day_length_min);
    
    
    url_27_day_length_sec = url_27_split_data4(3,:);
    url_27_day_length_sec_str = cellstr(url_27_day_length_sec);
    url_27_day_length_sec_1 = split(url_27_day_length_sec_str);
    url_27_day_length_sec_mat = str2double(url_27_day_length_sec_1(1));
    url_27_total_time_1 = url_27_day_length_hr_mat*60 + url_27_day_length_min_mat + url_27_day_length_sec_mat/60;

    url_28 = [ link, Year_char,  cn, Month_char,  cn, D_char(108:109) ];
    web_28 = webread(url_28);
    data_table_url_28 = struct2table(web_28);

    data_table_url_28_data2 = data_table_url_28(:,1);
    data_table_url_28_data3 = table2array(data_table_url_28_data2);
    data_table_url_28_data4 = struct2cell(data_table_url_28_data3);

    day_length_T_url_28 = data_table_url_28_data4(3);

    table2array(day_length_T_url_28);
    url_28_split_data4 = split(day_length_T_url_28, ':');
    url_28_day_length_hr = url_28_split_data4(1,:);

    url_28_day_length_hr_mat = str2double(url_28_day_length_hr);

    url_28_day_length_min = url_28_split_data4(2,:);
    url_28_day_length_min_mat = str2double(url_28_day_length_min);
    
    
    url_28_day_length_sec = url_28_split_data4(3,:);
    url_28_day_length_sec_str = cellstr(url_28_day_length_sec);
    url_28_day_length_sec_1 = split(url_28_day_length_sec_str);
    url_28_day_length_sec_mat = str2double(url_28_day_length_sec_1(1));
    url_28_total_time_1 = url_28_day_length_hr_mat*60 + url_28_day_length_min_mat + url_28_day_length_sec_mat/60;

    url_29 = [ link, Year_char,  cn, Month_char,  cn, D_char(112:113) ];
    web_29 = webread(url_29);
    data_table_url_29 = struct2table(web_29);

    data_table_url_29_data2 = data_table_url_29(:,1);
    data_table_url_29_data3 = table2array(data_table_url_29_data2);
    data_table_url_29_data4 = struct2cell(data_table_url_29_data3);

    day_length_T_url_29 = data_table_url_29_data4(3);

    table2array(day_length_T_url_29);
    url_29_split_data4 = split(day_length_T_url_29, ':');
    url_29_day_length_hr = url_29_split_data4(1,:);

    url_29_day_length_hr_mat = str2double(url_29_day_length_hr);

    url_29_day_length_min = url_29_split_data4(2,:);
    url_29_day_length_min_mat = str2double(url_29_day_length_min);
    
    
    url_29_day_length_sec = url_29_split_data4(3,:);
    url_29_day_length_sec_str = cellstr(url_29_day_length_sec);
    url_29_day_length_sec_1 = split(url_29_day_length_sec_str);
    url_29_day_length_sec_mat = str2double(url_29_day_length_sec_1(1));
    url_29_total_time_1 = url_29_day_length_hr_mat*60 + url_29_day_length_min_mat + url_29_day_length_sec_mat/60;

    
    url_30 = [ link, Year_char,  cn, Month_char,  cn, D_char(116:117) ];
    web_30 = webread(url_30);
    data_table_url_30 = struct2table(web_30);

    data_table_url_30_data2 = data_table_url_30(:,1);
    data_table_url_30_data3 = table2array(data_table_url_30_data2);
    data_table_url_30_data4 = struct2cell(data_table_url_30_data3);

    day_length_T_url_30 = data_table_url_30_data4(3);

    table2array(day_length_T_url_30);
    url_30_split_data4 = split(day_length_T_url_30, ':');
    url_30_day_length_hr = url_30_split_data4(1,:);

    url_30_day_length_hr_mat = str2double(url_30_day_length_hr);

    url_30_day_length_min = url_30_split_data4(2,:);
    url_30_day_length_min_mat = str2double(url_30_day_length_min);
    
    
    url_30_day_length_sec = url_30_split_data4(3,:);
    url_30_day_length_sec_str = cellstr(url_30_day_length_sec);
    url_30_day_length_sec_1 = split(url_30_day_length_sec_str);
    url_30_day_length_sec_mat = str2double(url_30_day_length_sec_1(1));
    url_30_total_time_1 = url_30_day_length_hr_mat*60 + url_30_day_length_min_mat + url_30_day_length_sec_mat/60;
    
    url_31 = [ link, Year_char,  cn, Month_char,  cn, D_char(120:121) ];
    web_31 = webread(url_31);
    data_table_url_31 = struct2table(web_31);

    data_table_url_31_data2 = data_table_url_31(:,1);
    data_table_url_31_data3 = table2array(data_table_url_31_data2);
    data_table_url_31_data4 = struct2cell(data_table_url_31_data3);

    day_length_T_url_31 = data_table_url_31_data4(3);

    table2array(day_length_T_url_31);
    url_31_split_data4 = split(day_length_T_url_31, ':');
    url_31_day_length_hr = url_31_split_data4(1,:);

    url_31_day_length_hr_mat = str2double(url_31_day_length_hr);

    url_31_day_length_min = url_31_split_data4(2,:);
    url_31_day_length_min_mat = str2double(url_31_day_length_min);
    
    
    url_31_day_length_sec = url_31_split_data4(3,:);
    url_31_day_length_sec_str = cellstr(url_31_day_length_sec);
    url_31_day_length_sec_1 = split(url_31_day_length_sec_str);
    url_31_day_length_sec_mat = str2double(url_31_day_length_sec_1(1));
    url_31_total_time_1 = url_31_day_length_hr_mat*60 + url_31_day_length_min_mat + url_31_day_length_sec_mat/60
    
%     Y_data= [ url_1_total_time_1 url_2_total_time_1 url_3_total_time_1 url_4_total_time_1
%     url_5_total_time_1 url_6_total_time_1 url_7_total_time_1 url_8_total_time_1
%     url_9_total_time_1 url_10_total_time_1 url_11_total_time_1 url_12_total_time_1
%     url_13_total_time_1 url_14_total_time_1 url_15_total_time_1 url_16_total_time_1
%     url_17_total_time_1 url_18_total_time_1 url_19_total_time_1 url_20_total_time_1
%     url_21_total_time_1 url_22_total_time_1 url_23_total_time_1 url_24_total_time_1
%     url_25_total_time_1 url_26_total_time_1 url_27_total_time_1 url_28_total_time_1
%     url_29_total_time_1 url_30_total_time_1 url_31_total_time_1 ];
% plot(D,Y_data)

end


%% Close the serial port
fclose(a);
delete(a)
clear a;
disp('Serial Port is closed')