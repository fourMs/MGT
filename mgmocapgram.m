function rgb = mgmocapgram(d)
r = zeros(d.nMarkers,d.nFrames);
g = zeros(d.nMarkers,d.nFrames);
b = zeros(d.nMarkers,d.nFrames);
for i = 1:d.nMarkers
    for j = 1:d.nFrames
        r(i,j) = d.data(j,i*3-2);
        g(i,j) = d.data(j,i*3-1);
        b(i,j) = d.data(j,i*3);
    end
end
for i = 1:d.nMarkers
    r(i,:) = r(i,:)-min(r(i,:));r(i,:) = r(i,:)./max(r(i,:));
    g(i,:) = g(i,:)-min(g(i,:));g(i,:) = g(i,:)./max(g(i,:));
    b(i,:) = b(i,:)-min(b(i,:));b(i,:) = b(i,:)./max(b(i,:));
end
rgb(:,:,1) = r;
rgb(:,:,2) = g;
rgb(:,:,3) = b;
