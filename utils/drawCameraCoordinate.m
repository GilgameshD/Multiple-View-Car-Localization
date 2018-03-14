function drawCameraCoordinate(Sx,Sy,Sz,Spx,Spy,Spz,c)
    hold on;
    % draw O and O' and [0,0,0]
    plot3(0, 0, 0, 'k.', 'markersize', 20); hold on;
    plot3(Spz(1,1),Spz(2,1),Spz(3,1), c, 'markersize', 20); hold on;
    arrow_size = 100;

    h1=quiver3(Sx(1,1), Sx(2,1), Sx(3,1), Sx(1,2)-Sx(1,1), Sx(2,2)-Sx(2,1), Sx(3,2)-Sx(3,1), 'color', 'b'); set(h1,'maxheadsize',arrow_size); 
    h2=quiver3(Sy(1,1), Sy(2,1), Sy(3,1), Sy(1,2)-Sy(1,1), Sy(2,2)-Sy(2,1), Sy(3,2)-Sy(3,1), 'color', 'g'); set(h2,'maxheadsize',arrow_size); 
    h3=quiver3(Sz(1,1), Sz(2,1), Sz(3,1), Sz(1,2)-Sz(1,1), Sz(2,2)-Sz(2,1), Sz(3,2)-Sz(3,1), 'color', 'r'); set(h3,'maxheadsize',arrow_size); 
    h4=quiver3(Spx(1,1),Spx(2,1),Spx(3,1),Spx(1,2)-Spx(1,1),Spx(2,2)-Spx(2,1),Spx(3,2)-Spx(3,1), 'color', 'b'); set(h4,'maxheadsize',arrow_size);
    h5=quiver3(Spy(1,1),Spy(2,1),Spy(3,1),Spy(1,2)-Spy(1,1),Spy(2,2)-Spy(2,1),Spy(3,2)-Spy(3,1), 'color', 'g'); set(h5,'maxheadsize',arrow_size);
    h6=quiver3(Spz(1,1),Spz(2,1),Spz(3,1),Spz(1,2)-Spz(1,1),Spz(2,2)-Spz(2,1),Spz(3,2)-Spz(3,1), 'color', 'r'); set(h6,'maxheadsize',arrow_size);
end