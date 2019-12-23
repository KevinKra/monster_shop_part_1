class CartController < ApplicationController
  before_action :restrict_admin, :require_current_user

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    flash[:notice] = "Item has been removed from the cart"
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def edit_quantity
    item = Item.find(params[:item_id])
    if params[:quantity] == "add" && item.inventory > session[:cart][params[:item_id]]
      session[:cart][params[:item_id]] += 1
      redirect_to '/cart'
    elsif params[:quantity] == "add"
      flash[:error] = "Out of stock"
      redirect_to '/cart'
    elsif params[:quantity] == "subtract" && session[:cart][params[:item_id]] > 1
      session[:cart][params[:item_id]] -= 1
      redirect_to '/cart'
    elsif params[:quantity] == "subtract" && session[:cart][params[:item_id]] == 1
      remove_item
    end
  end

  private
    def restrict_admin
      redirect_to "/public/404" if current_admin?
    end

    def require_current_user
      flash[:warning] = "Warning: You must register or log in to finish the checkout process"
    end
end
