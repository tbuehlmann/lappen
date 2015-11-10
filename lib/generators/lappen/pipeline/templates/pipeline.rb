<% module_namespacing do -%>
class <%= class_name %>Pipeline < <%= subclass %>
  # Configure Filters here:
  #
  # use Lappen::Filters::Kaminari, page_key: 'page', per_key: 'per'
  # use Lappen::Filters::Orderer, :foo, :bar, :baz
  # use Lappen::Filters::Pundit
end
<% end -%>
