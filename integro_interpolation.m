% �������� ��������  
a = 0; % ����� ������� ���������  
b = 2; % ������ ������� ���������  
gamma_1 = 1;   
gamma_2 = 3;  
phi_2 = 3;  
L = 2;

% �������� �����  
N = 8;   
h = [0.2, 0.4, 0.2, 0.4, 0.2, 0.2, 0.4];  
h_N = N-1;
x = zeros(N, 1);  
x(1) = a;  
for i = 2:N  
    x(i) = x(i-1) + h(i-1);  
end  

% �������-�����������
k = @(x) 1;
q = @(x) 1;
f = @(x) 1;
tilda_h = @(i) (h(i)+h(i+1))/2;

% ��������������� �����  
half_x_N = N - 1; % ���������� ����� �� ��������������� �����  
half_h_N = half_x_N - 1; % ���������� ����� �� ��������������� �����
half_x = zeros(half_x_N, 1); 
half_h = zeros(half_h_N, 1); 

% ���������� �������� ����� ��������������� �����  
for i = 1:half_x_N  
    half_x(i) = (x(i) + x(i + 1)) / 2; % �������� ���������� x  
end  

% ���������� ������� ����� ��������������� ����� 
for i = 1:half_h_N
    half_h(i) = (h(i) + h(i+1)) / 2; % ������� �������� h ����� ��������� ���������  
end  

% ����� ����������� ��� ��������  
disp('�������� ����� x:');  
disp(x);  
disp('��������������� ����� half_x:');  
disp(half_x);  
disp('���� h_half:');  
disp(half_h);

% ������������
a = zeros(N, 1);
b = zeros(N, 1);
c = zeros(N, 1);

% A * v = g
A = zeros(N);
v = zeros(N, 1);
g = zeros(N, 1);

% ������������ �� ���������� ����� ��� ����� �������
b(1) = 0;
c(1) = 1;
g(1) = gamma_1;

% ������������ �� ���������� ����� ��� ���������� �����
for i = 1:N-2
    a(i+1) = -(k(half_x(i))/h(i));
    b(i+1) = -(k(half_x(i+1))/h(i+1));
    c(i+1) = k(half_x(i))/h(i) + k(half_x(i+1))/h(i+1) + tilda_h(i)*q(x(i+1)); %f(x(i+1))?
    g(i+1) = tilda_h(i)*f(x(i));
end

% ������������ �� ���������� ����� ��� ������ �������
a(N) = -k(half_x(half_x_N))/h(length(h));
c(N) = k(half_x(half_x_N))/h(length(h)) + h(h_N)/2*q(x(N)) + phi_2;
g(N) = h(h_N)/2 * f(x(N)) + gamma_2;

% ���������� �������������� �������: a - �����, � - �� ������� ���������,
% b - ������
for i = 1:N
    A(i, i) = c(i); % ����������� ���������
    if i > 1  
        A(i,i-1) = a(i); % ����� ��������� (������� �� ������� ��������)  
    end  
    if i < N  
        A(i,i+1) = b(i); % ������ ��������� (�� �������������� ��������)  
    end  
end
    
% ������ ����������  
disp('���������������� ������� ������������� A:');  
disp(A); 
disp('������ ������������ g');
disp(g);


% ����� ��������  
% ������ ���  
alpha = zeros(N, 1);  
beta = zeros(N, 1);  
alpha(1) = c(1); 
beta(1) = g(1); 

for i = 2:N  
    alpha(i) = c(i) - a(i) * b(i-1) / alpha(i-1);  
    beta(i) = g(i) - a(i) * beta(i-1) / alpha(i-1);  
end  

% �������� ���  
v = zeros(N, 1);  
v(N) = beta(N) / alpha(N);  

for i = N-1:-1:1  
    v(i) = (beta(i) - b(i) * v(i+1)) / alpha(i);  
end  

plot(x, v)
xlabel('x (����� �����)');  
ylabel('����������� V(x)');
title('������������� ����������� � �����');
xticks(half_x); % ������ ��������������� ����� �� ��� � 
xticklabels(arrayfun(@num2str, half_x, 'UniformOutput', false));  

grid on; 