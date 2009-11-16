class PageLink < MenuLink

  def url
    page = Page.find(self.target_id)
    "/#{page.url}"
  end
end
