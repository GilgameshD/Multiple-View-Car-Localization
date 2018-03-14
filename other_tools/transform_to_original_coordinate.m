function model = transform_to_original_coordinate(model, center, scale)

    width = 200*scale;

    model(1,:) = model(1,:).*width./64+center(1)-width/2;
    model(2,:) = model(2,:).*width./64+center(2)-width/2;
   
end