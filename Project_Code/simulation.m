%fileID = fopen('Facebook.txt','r');
M=csvread('Email.csv');
theta=0.5;
global size
global spreader
global immune 
global ignorant
global p
global prob
global graph 
global payoff
global h1
global h2
h1=0;
h2=0;
p=0.15;
alpha=1;
size=5000;
rnds=50;
graph=zeros(size,size);
spreader = zeros(rnds,size);
immune = zeros(rnds,size);
ignorant = ones(rnds,size);
degree=zeros(1,size);
weight=zeros(size,size);
prob=zeros(size,size);
sums=zeros(1,size);
payoff=zeros(1,size);
fcount=zeros(3,rnds);
numof=zeros(1,size);
Beta=0.1;
% disp(M(i,1))
% disp(M(i,2))
for i=1:20361
    if M(i,1) <= size && M(i,2) <= size
        graph(M(i,1),M(i,2))=1;
        graph(M(i,2),M(i,1))=1;
        degree(M(i,1))= degree(M(i,1))+1;
        degree(M(i,2))= degree(M(i,2))+1;
    end
end

disp('done with degree calculation');
for i=1:size
    for j=1:size      
        weight(i,j)=(degree(i)*degree(j))^0.8;
        sums(i)=sums(i)+weight(i,j);
    end
end

for i=1:size
    for j=1:size
        weight(i,j)=weight(i,j)/sums(i);
    end
end

sums=zeros(1,size);
for i=1:size
    for j=1:size
        if graph(i,j)==1 || graph(j,i)==1
            sums(i)=sums(i)+(weight(i,j)^alpha);
        end
    end
end

for i=1:size
    for j=1:size
        if graph(i,j)==1 || graph(j,i)==1
            prob(i,j)=(weight(i,j)^alpha)/sums(i);   
        else
            prob(i,j) = 0;
        end
    end
    prob(i,i)=0;
end

disp('done with prob calculation');

%  for i=1:100
%      disp(weight(1,i));
%      disp('sos');
%      disp(prob(1,i));
%  end

for k=1:rnds
    
    disp('starting round');
    disp(k);
    r = randi([1 size],1,50);
    for i=1:50
        spreader(k,r(i))=1;
        ignorant(k,r(i))=0;
        immune(k,r(i))=0;
        for j=1:size
            if graph(r(i),j)==1 && j~=r(i)
                dfs(j,k);
            end
        end
    end
   % disp(h1);
   % disp(h2);
    for i=1:size
        fcount(1,k)=fcount(1,k)+spreader(k,i);
        fcount(2,k)=fcount(2,k)+ignorant(k,i);
        fcount(3,k)=fcount(3,k)+immune(k,i);
    end
    
    
    for i=1:size
        if spreader(k,i)==1
            payoff(i)=1;
        else
            payoff(i)=0;
        end
    end
    
   
    if fcount(1,k)>= Beta*size
        cnt=1;
        for i=1:size
            if spreader(k,i)==1
               numof(cnt)=i;
               cnt=cnt+1;
            end
        end
        
        s=fcount(1,k)/10;
        s=floor(s);
        
        r=randi([1 fcount(1,k)],1,s);
        for i=1:s
            payoff(numof(r(i)))=-1;
        end
    end
end

fcount10 = fcount;
disp(fcount);
fcount = fcount/size;
plot(fcount(1,:),'r')
hold on
plot(fcount(2,:),'b')
plot(fcount(3,:),'g')

