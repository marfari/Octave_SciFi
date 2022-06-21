function area = circular_segment_area(radius, sagitta)

  if (radius <= 0)
    area = 0;
  elseif (sagitta <= 0) 
    area = 0;
  elseif (sagitta >= 2.0*radius)
    area = radius^2 * pi;
  else
    theta = 2.0*acos((radius-sagitta)/radius);
    area = 0.5*radius^2*(theta - sin(theta));
  end;
