X_train = readmatrix('path of dataset');
Y = readmatrix('path of dataset');

[numData,numFeature] = size(X_train);
Y_unique = unique(Y);
k = length(Y_unique);
v = zeros(numData,numFeature);
for i = 1:length(Y_unique)
    p = find(Y==Y_unique(i));
    v0 = mean( X_train(p,:),1 );
    v(p,:) = repmat(v0,length(p),1);
    n_max(i) = length(p);
end
n_max = max(n_max);

X = X_train;
t = 1;
step = exp([0:0.5:10])-1;
Ratio = [];
JC = [];
FM = [];
Rand = [];
for i = 1:length(step)
    X_train = X + step(i)*v;
    [delta,epsilon]= DeltaEpsilon(X_train,Y);
    Ratio(t) = log(delta/epsilon+1);
    s(i) = rng;
    %s = seed.s;
    rng(s(i));
    idx = kmeans(X_train,k);
    JC(t) = ExternalIndex(Y,idx,'JC');
    FM(t) = ExternalIndex(Y,idx,'FM');
    Rand(t) = ExternalIndex(Y,idx,'Rand');
    t = t + 1;
end

[Ratio,I] = sort(Ratio);
JC = JC(I);
FM = FM(I);
Rand = Rand(I);

JC_normalized = (JC - min(JC))/(max(JC) - min(JC));
FM_normalized = (FM - min(FM))/(max(FM) - min(FM));
Rand_normalized = (Rand - min(Rand))/(max(Rand) - min(Rand));

plot(Ratio,JC,'-*','LineWidth',2.5,'MarkerSize',12)
hold on
plot(Ratio,FM,'-+','LineWidth',2.5,'MarkerSize',12)
hold on
plot(Ratio,Rand,'-o','LineWidth',2.5,'MarkerSize',12)
hold on
plot(log([(n_max - 1)/2,(n_max - 1)/2]+1),[0,2],'--','LineWidth',2.5,'MarkerSize',12)
ylim([0.4 1.05])
xlabel('$\ln(\delta/\varepsilon+1)$','Interpreter','latex','FontSize',30)
ylabel('CEE Index','FontSize',27)
legend('JC','FM','Rand','$\ln(\delta / \varepsilon+1)=\ln(\frac{n_{max}-1}{2}+1)$','Location','southeast','FontSize',20,'Interpreter','latex')
set(gca,'FontSize',25)
