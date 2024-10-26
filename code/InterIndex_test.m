load wine_dataset
k = 3;
X_train = wineInputs';
for i = 1:3
    p = find(wineTargets(i,:)==1);
    wineTargets(i,p) = i;
end
Y = sum(wineTargets);
%%
[numData,numFeature] = size(X_train);
Y_unique = unique(Y);
v = zeros(numData,numFeature);
for i = 1:length(Y_unique)
    p = find(Y==Y_unique(i));
    v0 = mean( X_train(p,:),1 );
    v(p,:) = repmat(v0,length(p),1);
end
%%
X = X_train;
t = 1;
for i = 0:1:20
    X_train = X + i*v;
    [delta,epsilon]= DeltaEpsilon(X_train,Y);
    Ratio(t) = delta/epsilon;
    DB(t) = InterIndex(X_train,Y,'DB');
    Dunn(t) = InterIndex(X_train,Y,'Dunn');
    Sil(t) = InterIndex(X_train,Y,'Sil');
    XB(t) = InterIndex(X_train,Y,'XB');
    t = t + 1;
end

[Ratio,I] = sort(Ratio);
DB = DB(I);
Dunn = Dunn(I);
Sil = Sil(I);
XB = XB(I);

DB_normalized = (DB - min(DB))/(max(DB) - min(DB));
Dunn_normalized = (Dunn - min(Dunn))/(max(Dunn) - min(Dunn));
Sil_normalized = (Sil - min(Sil))/(max(Sil) - min(Sil));
XB_normalized = (XB - min(XB))/(max(XB) - min(XB));

plot(Ratio,DB_normalized,'-*',Ratio,Dunn_normalized,'-+',...
Ratio,Sil_normalized,'-o',Ratio,XB_normalized,'-x','LineWidth',2.5,'MarkerSize',12)
legend('DB','Dunn','Sil','XB') 
set(gca,'FontSize',25)
xlabel('$x=\delta/\varepsilon$','FontSize',30,'Interpreter','latex')
ylabel('Internal Index','FontSize',27)