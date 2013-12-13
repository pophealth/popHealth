module PaginationHelper


  def paginate(base_url,collection)
    set_pagination_params
    count = collection.count
    links = generate_links(base_url,count,@per_page,@page)
    response.headers["Link"] = links.join(",") if !links.empty?
    collection.skip(@offset).limit(@per_page)
  end

  def generate_links(base_url,count,per_page,page)
    links = []
    total_pages = count/per_page
    total_pages = total_pages +1 if (count%per_page ) != 0
    next_page = page < total_pages
    prev_page = page > 1 && total_pages != 1

    links << generate_link(base_url,1,per_page,"first") if total_pages > 1
    links << generate_link(base_url,total_pages,per_page,"last") if total_pages != 1
    links << generate_link(base_url,page-1,per_page,"prev") if prev_page
    links << generate_link(base_url,page+1,per_page,"next") if next_page
    links
  end

  def generate_link(base_url, page, per_page, rel)
    %{<#{base_url}?page=#{page}&per_page=#{per_page}>; rel="#{rel}" }
  end

  def set_pagination_params
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || 100).to_i
    @per_page = 100 if @per_page > 100
    @offset = (@page-1)*@per_page
  end

end
