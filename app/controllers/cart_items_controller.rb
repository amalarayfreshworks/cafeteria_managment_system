class CartItemsController < ApplicationController
  before_action :ensure_cart_created

  def create
    # id = params[:id]

    chosen_item = MenuItem.find_by(id: params[:menu_item_id])
    current_cart = @current_cart
    if current_cart.menu_items.include?(chosen_item)
      @cart_item = current_cart.cart_items.find_by(:menu_item_id => chosen_item)
      @cart_item.quantity += 1
    else
      @cart_item = CartItem.new
      @cart_item.cart = current_cart
      @cart_item.quantity = 1
      @cart_item.menu_item = chosen_item
    end
    @cart_item.save
    #render plain: @cart_item.cart
    #redirect_to cart_path(current_cart)
    redirect_to menu_items_path
  end

  def total_price
    self.quantity * self.product.price
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path(@current_cart)
  end

  def add_quantity
    @cart_item = CartItem.find(params[:id])
    @cart_item.quantity += 1
    @cart_item.save
    redirect_to cart_path(@current_cart)
  end

  def reduce_quantity
    @cart_item = CartItem.find(params[:id])
    if @cart_item.quantity > 1
      @cart_item.quantity -= 1
    end
    @cart_item.save
    redirect_to cart_path(@current_cart)
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id, :cart_id)
  end
end
