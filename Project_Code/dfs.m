function h=dfs(source,round)
    global p
    global size
    global spreader
    global immune
    global ignorant
    global prob
    global payoff
    global graph
 
   if spreader(round,source)==1
        return;
   end
   if immune(round,source)==1
       return;
   end
   
   if round ==1
       P=[0.5 0.5];
       X=[0 1];
       f=probpick(P,X);
       if f==1
           spreader(round,source)=1;
           ignorant(round,source)=0;
           for i=1:size
               if graph(source,i)==1 && i~=source
                dfs(i,round);
               end
           end
       end
       
       if f==0
           immune(round,source)=1;
           ignorant(round,source)=0;
       end
       return;
   end
   
   P=[p 1-p];
   X=[0 1];
   f=probpick(P,X);
   if f==0
       ignorant(round,source)=0;
       immune(round,source)=1;
       return;
   end
   
   P=zeros(1,size);
   X=zeros(1,size);
  
   for j=1:size
         P(j)=prob(source,j);
         X(j)=j;
   end
   
   f=probpick(P,X);
   val=1/(1+ exp(-(payoff(f)-payoff(source))/0.1));
   P=[val 1-val];
   X=[1 0];
   temp=probpick(P,X);
   if temp==1
       if ignorant(round-1,f)==1
            return;
       end
       
       if spreader(round-1,f)==1
           spreader(round,source)=1;
           ignorant(round,source)=0;
           for i=1:size
               if graph(source,i)==1 && i~=source
                dfs(i,round);
               end
           end
           return;
       end
       
       if immune(round-1,f)==1
           immune(round,source)=1;
           ignorant(round,source)=0;
           return;
       end
   end
   
   if temp==0
       if ignorant(round-1,f)==1
%            spreader(round,source)=1;
%            ignorant(round,source)=0;
%            for i=1:size
%                if graph(source,i)==1 && i~=source
%                 dfs(i,round);
%                end
%            end
           return;
       end
       
%        if spreader(round-1,f)==1
%            immune(round,source)=1;
%            ignorant(round,source)=0;
%            return;
%        end
       
%        if immune(round-1,f)==1
%            spreader(round,source)=1;
%            ignorant(round,source)=0;
%            for i=1:size
%                if graph(source,i)==1 && i~=source
%                 dfs(i,round);
%                end
%            end
%            return;
%        end
   end
end