module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = 'Ruby on Rails Tutorial Sample App'
    if @title.nil?
      base_title
    else
      "#{base_title} | #@title"
    end
  end

  def logo
    image_tag('logo.png', :alt => 'Sample App', :class => 'round' )
  end

  def sign_in_out_link
    signed_in? ? link_to('Sign out', signout_path, :method => :delete)
               : link_to('Sign in',  signin_path)
  end

end
