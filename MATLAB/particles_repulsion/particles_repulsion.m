% particles with simple 1/r repulsion force

sim_num = 3;
Dim = 3;
L = 5;
Nb = 2;
repulsion_coef = 0.001;
noise_coef = 0.01;

movie = 0; % 0: no movie, 1: 1 movie
kmov = 1;
frame_rate = 14;

v = makeMovie(movie,sim_num,frame_rate);

Tme  = 40;
dt = 0.01;
N = Tme/dt;
colorz = linspace(0.01,1,N);

X = L.*(rand(Nb,Dim));
A = ones(Nb,Dim);
U = rand(Nb,Dim);

for step  = 1:N

    X = mod(X,L);
    
    for j = 1:Nb
            [~,z,D,x,y] = periodicDist(X(j,:),X(1:end ~= j,:),L,Dim);
            switch Dim
                case 2
                    A(j,:) = sum(([x,y])./(sum(D)+eps));
                case 3
                    A(j,:) = sum(([x,y,z])./(sum(D)+eps));
            end
    end

    U = U - repulsion_coef.*dt.*A ;
    X = X + dt*U+ dt*noise_coef.*rand(Nb,Dim);


    if (mod(step,40) == 0)
        v = makeMovieFrame(X, L, Dim,movie,v,colorz,kmov,step);
        kmov = kmov+1;
        switch movie
            case 0
                makePlot(X, L, Dim,colorz(step))
        end
        
    end

end

switch movie
    case 1
        close(v)
end


function [Idx2,dz1,D2,dx1,dy1] = periodicDist(ZI,ZJ,L,Dim,varargin)


dx1 = abs(ZI(:,1)-ZJ(:,1));
dx1(dx1 > L/2) = L - dx1(dx1 > L/2);
dy1 = abs(ZI(:,2)-ZJ(:,2));
dy1(dy1 > L/2) = L - dy1(dy1 > L/2);
dz1 = zeros(size(dx1));
switch Dim
    case 2
        D2 = sqrt(dy1.^2+dx1.^2);
    case 3
        dz1 = abs(ZI(:,3)-ZJ(:,3));
        dz1(dz1 > L/2) = L - dz1(dz1 > L/2);
        D2 = sqrt(dy1.^2+dx1.^2+dz1.^2);
end       
Idx2 = 1:length(ZJ);

switch nargin
    case 5
        interactionRange = varargin{1};
        Idx2 = Idx2(D2 <= interactionRange);
        D2 = D2(D2 <= interactionRange);
end

end


function X = uniformX(Nb,L)
X = zeros(Nb,2);
for i=1:Nb
   myrand = rand(1,2)-0.5;
   X(i,:) = L/2+L*myrand;
end
end


function v = makeMovie(movie,simnum,fRate)
movieTitle = "spheres"+num2str(simnum)+".avi";
switch movie
    case 1
    % make video 1
    v = VideoWriter(movieTitle);
    v.Quality = 100;
    v.FrameRate = fRate;
    open(v)
    case 0
    v = 0;
end
end



function v = makeMovieFrame(X, L, Dim,movie,v,colorz,kmov,step)
switch movie
    case 1
        makePlot(X, L, Dim,colorz(step))
        F1(kmov) = getframe(gcf);
        writeVideo(v,F1(kmov));
        close all;
end

end

function makePlot(X, L, Dim,Color)

marker_type = 'sphere'; %sphere or dot 

switch Dim
    % 2dplot
    case 2
        plot(X(1,1),X(1,2),'o', 'MarkerSize', 7 + 3*Color,MarkerFaceColor= [0 Color 0.5], MarkerEdgeColor= [0 1-Color 0.5]);
        hold on;plot(X(2,1),X(2,2),'o', 'MarkerSize', 7 + 3*Color, MarkerFaceColor= [Color 0 0],MarkerEdgeColor= [1-Color 0 0]);
    % 3dplot
    case 3
        switch marker_type
            % flat plot
            case 'dot'
                scatter3(X(:,1),X(:,2),X(:,3),100 + 200*Color,[Color 0 0;0 Color 0.5],'filled')
                axis off
            % show particles as spheres 
            case 'sphere'
                [x_s, y_s, z_s] = sphere;
                size_s =  0.1 + Color/4;
                positions=[X(1,:) size_s;X(2,:) size_s];
                s1=surf(x_s*positions(1,4)+positions(1,1),y_s*positions(1,4)+positions(1,2),z_s*positions(1,4)+positions(1,3),...
                    'FaceAlpha',0.6, 'FaceColor',[Color 0 0]);
                s1.EdgeColor = 'none';
                hold on
                s2=surf(x_s*positions(2,4)+positions(2,1),y_s*positions(2,4)+positions(2,2),z_s*positions(2,4)+positions(2,3),...
                    'FaceAlpha',0.7); 
                s2.EdgeColor = 'none';
                colormap("bone") % bone and pink are also cool!
                daspect([1 1 1])
        end
        % set the angle and  z axis limits
        view(40,35)
        zlim([0 L])
end
drawnow
hold on;

% set the axis limits
xlim([0 L])
ylim([0 L])

end

