class PaginationSection < SitePrism::Section
  def go_to_page(page)
    click_link page.to_s
    Home.new
  end
end
