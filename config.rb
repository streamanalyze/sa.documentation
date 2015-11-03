activate :livereload
activate :directory_indexes
activate :autoprefixer

set :markdown, tables: true,
               autolink: true,
               gh_blockcode: true,
               fenced_code_blocks: true,
               with_toc_data: true,
               footnote_backlink: nil
set :markdown_engine, :kramdown

configure :development do
  set :debug_assets, true
end

configure :build do
  activate :minify_css
  activate :minify_javascript
end

helpers do
  def active_link_to(caption, url, options = {})
    if current_page.url == "#{url}/"
      options[:class] = 'doc-item-active'
    end
    link_to(caption, url, options)
  end
end
