# -*- coding: utf-8 -*-
module Admin::ApplicationHelper
  def streamlined_top_menus
    [
     ["Компании", { :controller=> 'companies'}],
     ["Федеральные номера", { :controller=> 'telefon_federals'}],
     ["Смена номера", { :controller=> 'telefon_renames'}],
     ["Пользователи", { :controller=> 'users'}],
     ["Категории", { :controller=> 'categories'}],
     ["Тэги", { :controller=> 'tags'}],
     ["Joba", { :controller=> 'jobs'}],
     ["Storages", { :controller=> 'storages'}],
    ]
  end
end
