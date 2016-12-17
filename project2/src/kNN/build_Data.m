function data = build_Data (empty_element)
    load u.data;

    count_users = 943;
    count_itens = 1682;

    MovieLens = empty_element * ones (count_users, count_itens);

    for k = 1:length(u)
        MovieLens(u(k, 1), u(k,2)) = u(k, 3);
    end

    save MovieLens;
    
    data = MovieLens;

end

