function [f1Sepr,f2Sepr]=findSepratedSignals1(f,A1,A2)
    theta2=randn(128,1);
    f2Sepr=A2*theta2;
    change=10^5;oldError=0;epsilon=1e-4;
    while change> epsilon
    %nItter=50;
    %for i=1:nItter
        % f2Sepr fixed
        y=f-f2Sepr;
        %theta1=omp(y,A1,1);
        %theta1=ompInterBased(y,A1,0.00001,20);
        theta1=ISTA(y,A1,1.7,0.0001,5);
        f1Sepr=A1*theta1;
        % f1Sepr fixed
        y=f-f1Sepr;
        theta2=ISTA(y,A2,1.7,0.0001,5);      
        f2Sepr=A2*theta2;
        %[theta2,r]=omp(y,A2,1);
        %[theta2,r]=ompInterBased(y,A2,0.00001,20);
        diff=norm(y-(f1Sepr+f2Sepr));
        change=abs(oldError-diff);
        fprintf('diff:%f\tchange:%f\n',diff,change);        
        oldError=diff;        
    end
end