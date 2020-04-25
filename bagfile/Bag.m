%clear all
% rosbag info '/Users/abilioazevedo/Desktop/turtle.bag';
bag = rosbag('/Users/abilioazevedo/Desktop/turtle.bag');
%bag = rosbag('/Users/abilioazevedo/Desktop/wheelchair.bag');

% frames = bag.AvailableFrames
% messageList = bag.MessageList
[xPoints,yPoints]=getGlobalTrajectory(bag);
[xPoints2,yPoints2]=getLocalTrajectory(bag);
[xPoints3,yPoints3]=getTrajectory(bag);
%plotDataTrajectory(xPoints,yPoints,xPoints2,yPoints2,xPoints3,yPoints3);
[x,diffTotal]=plotDiff(xPoints,yPoints,xPoints2,yPoints2,xPoints3,yPoints3);

function [x,diffTotal] = plotDiff(xPoints,yPoints,xPoints2,yPoints2,xPoints3,yPoints3)
    newxPoints=xPoints2;
    newyPoints=yPoints2;
    newxPoints2=xPoints3;
    newyPoints2=yPoints3;
    pointsSize=size(newxPoints,2);
    pointsSize2=size(newxPoints2,2);
    rate=pointsSize/pointsSize2;
    mmc=lcm(pointsSize,pointsSize2);
    rate1=mmc/pointsSize;
    rate2=mmc/pointsSize2;
    newxPoints=interp(newxPoints,rate1);
    newyPoints=interp(newyPoints,rate1);
    newxPoints2=interp(newxPoints2,rate2);
    newyPoints2=interp(newyPoints2,rate2);
    % xPoints=xPoints(2:end);
    % yPoints=yPoints(2:end);
    % xPoints2=xPoints2(2:end);
    % yPoints2=yPoints2(2:end);
    diffX=newxPoints2-newxPoints;
    diffY=newyPoints2-newyPoints;
    diffTotal=abs(sqrt(diffX.^2-diffY.^2));
    x=(1:mmc);
    figure()
    plot(x,diffTotal*10,'o')
    xlabel('Amostras')
    ylabel('Distância da Trajetória Planejada (cm)')
    title('Gráfico de Erro na Trajetória')
end

function plotDataTrajectory(xPoints,yPoints,xPoints2,yPoints2,xPoints3,yPoints3)
%     newxPoints=xPoints(1:100);
%     newyPoints=yPoints(1:100);
%     newxPoints2=xPoints2(1:100);
%     newyPoints2=yPoints2(1:100);
   
    hold off
    figure()
    a(1)=scatter(xPoints,yPoints,'o','DisplayName','Trajetória Global Planejada');
    hold on
    a(2)=scatter(xPoints2,yPoints2,'o','DisplayName','Trajetória Local Planejada');
    a(3)=scatter(xPoints3,yPoints3,'o','DisplayName','Trajetória Real');

    legend(a)
    title('Trajetória completa execução 1')
end


function [xPoints,yPoints] = getGlobalTrajectory(bag)
    % rosbag info '/Users/abilioazevedo/Desktop/turtle.bag';
    %bag = rosbag('/Users/abilioazevedo/Desktop/wheelchair.bag');
    bag = rosbag('/Users/abilioazevedo/Desktop/wheelchair.bag');

    % frames = bag.AvailableFrames
    % messageList = bag.MessageList

    %bagselect = select(bag, 'Topic', '/move_base/NavfnROS/plan');
    bagselect = select(bag, 'Topic', '/trajectory');
    msgs=readMessages(bagselect,'DataFormat','struct');
    structs = cellfun(@(m) struct(m.Poses),msgs,'UniformOutput',false);
    structsarray=[];
    structsSize = size(structs,1);
    for c = 1:structsSize
        structPart = structs{c,1};
        sizePart=size(structPart,2);
        for d = 1:sizePart
            structsarray = [structsarray, structPart(d).Pose];
        end
    end

    structsarrayP=[];
    xPoints=[];
    yPoints=[];
    sizeStructsarray=size(structsarray,2);
    for e = 1:sizeStructsarray
        xPoints = [xPoints, structsarray(e).Position.X];
        yPoints = [yPoints, structsarray(e).Position.Y];
    end
end

function [xPoints3,yPoints3] = getLocalTrajectory(bag)
    %bagselect = select(bag, 'Topic', '/move_base/NavfnROS/plan');
    bagselect = select(bag, 'Topic', '/move_base/DWAPlannerROS/local_plan');
    msgs=readMessages(bagselect,'DataFormat','struct');
    structs = cellfun(@(m) struct(m.Poses),msgs,'UniformOutput',false);

    structsarray=[];
    structsSize = size(structs,1);
    for c = 1:structsSize
        structPart = structs{c,1};
        sizePart=size(structPart,2);
        for d = 1:sizePart
            structsarray = [structsarray, structPart(d).Pose];
        end
    end

    structsarrayP=[];
    xPoints3=[];
    yPoints3=[];
    sizeStructsarray=size(structsarray,2);
    for e = 1:sizeStructsarray
        xPoints3 = [xPoints3, structsarray(e).Position.X];
        yPoints3 = [yPoints3, structsarray(e).Position.Y];
    end
end

function [xPoints3,yPoints3] = getTrajectory(bag)
    bagselect2 = select(bag, 'Topic', '/tf');

    structs2=readMessages(bagselect2,'DataFormat','struct');
    xPoints3 =[];
    yPoints3 =[];
    structsSize2 = size(structs2,1);
    for c = 1:structsSize2
        structPart2 = structs2{c,1}.Transforms;
        if contains(structPart2(1).ChildFrameId, "base_footprint")
            xPoints3 = [xPoints3,structPart2.Transform.Translation.X];
            yPoints3 = [yPoints3,structPart2.Transform.Translation.Y];
        end
    end
end
