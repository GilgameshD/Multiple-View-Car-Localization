close all;

dataset = 'webots';
datapath = sprintf('pose-hg/pose-hg-demo/data/%s/',dataset);
predpath = sprintf('%s/../../exp/%s/',datapath,dataset);

cadSpecific = 0; % if you don't know the cad index for the instance, set this variable to 0

annotfile = sprintf('%s/annot/valid.mat',datapath);
camerafile = sprintf('%s/annot/camera.mat', datapath);
load(annotfile);
load(camerafile);
K = cameraParams.IntrinsicMatrix';

output_wp = cell(length(annot.imgname),1);
output_fp = cell(length(annot.imgname),1);

visible = 1;
for ID = 1:length(annot.imgname)
    
    % input
    imgname = annot.imgname{ID};
    center = annot.center(ID,:);
    scale = annot.scale(ID);
    class = annot.class{ID};
    indices = annot.indices{ID};
    cadID = annot.cad_index(ID);
    
    cad = load(sprintf('cad/%s.mat',class));
    cad = cad.(class);
    cad = cad(cadID);
    
    modelscale = 100;
%     cad.left_front_wheel = cad.left_front_wheel * modelscale;
%     cad.left_back_wheel = cad.left_back_wheel * modelscale;
%     cad.right_front_wheel = cad.right_front_wheel * modelscale;
%     cad.right_back_wheel = cad.right_back_wheel * modelscale;
%     cad.upper_left_windshield = cad.upper_left_windshield * modelscale;
%     cad.upper_right_windshield = cad.upper_right_windshield * modelscale;
%     cad.upper_left_rearwindow = cad.upper_left_rearwindow * modelscale;
%     cad.upper_right_rearwindow = cad.upper_right_rearwindow * modelscale;
%     cad.left_front_light = cad.left_front_light * modelscale;
%     cad.right_front_light = cad.right_front_light * modelscale;
%     cad.left_back_trunk = cad.left_back_trunk * modelscale;
%     cad.right_back_trunk = cad.right_back_trunk * modelscale;
    
    if cadSpecific
        dict = getPascalTemplate(cad);
    else
        dict = load(sprintf('dict/pca-%s.mat',class));
    end   
    dict.mu = dict.mu * modelscale;
    
    % read heatmaps and detect maximum responses
    heatmap = h5read(sprintf('%s/valid_%d.h5',predpath,ID),'/heatmaps');
    heatmap = permute(heatmap(:,:,indices(dict.kpt_id)),[2,1,3]);
    [W_hp,score] = findWmax(heatmap);
    W_im = transformHG(W_hp,center,scale,size(heatmap(:,:,1)),true);
    W_ho = K\[W_im;ones(1,size(W_im,2))];
    
    % pose optimization - weak perspective
    output_wp{ID} = PoseFromKpts_WP(W_hp,dict,'weight',score,'verb',false,'lam',1);
    output_fp{ID} = PoseFromKpts_FP(W_ho,dict,'R0',output_wp{ID}.R,'weight',score,'verb',false,'lam',1);
    
    S_fp = bsxfun(@plus,output_fp{ID}.R*output_fp{ID}.S,output_fp{ID}.T);
    [model_fp,w,~,T_fp] = fullShape(S_fp,cad);
    output_fp{ID}.T_metric = T_fp/w;    
    
    % visualization
    if visible == 1
        img = imread(sprintf('%s/images/%s',datapath,imgname));
        vis_wp(img,output_wp{ID},heatmap,center,scale,cad,dict);
        vis_fp(img, output_fp{ID}, output_wp{ID}, heatmap, center, scale, K, cad);
        pause
        close all
    end
    sprintf('finish one image... [%d]', ID);
end

annotation_path = './pose-hg/pose-hg-demo/data/webots/annot/';
save_path = sprintf('%sresult.mat', annotation_path);
save(save_path, 'output_wp', 'output_fp');



