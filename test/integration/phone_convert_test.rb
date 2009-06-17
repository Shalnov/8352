#require 'app/helpers/application_helper'
require 'app/helpers/telefon_renames_helper'
#require 'lib/acts_as_taggable/acts_as_taggable'# include ApplicationHelper

include ApplicationHelper

describe UserHelper do
#require File.dirname(__FILE__) + '/../../app/helpers'

#describe 'ApplicationHelper' do
  it "should not yield block for a non-admin" do
    should_receive(:current_user).and_return(@current_user)
    @current_user.should_receive(:admin?).and_return(false)

    html = content_for_admin do
      self._erbout << "<div>#{@block}</div>"
    end
    html.should_not have_tag('div', @block)
  end

end
