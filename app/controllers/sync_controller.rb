class SyncController < ApplicationController
  def index
    Deposit.sync_from_api

    redirect_to root_url
  end
end
