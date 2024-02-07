# spec/models/post_spec.rb

require 'rails_helper'

RSpec.describe Post, type: :model do
    context 'with valid attributes' do
        it 'is valid' do
            post = Post.new(title: 'My First Post', content: 'Hello, world!')
            expect(post).to be_valid
        end
    end

    context 'with invalid attributes' do 
        it 'is invalid without a title' do
            post = Post.new(content: 'Hello, world!')
            expect(post).to be_invalid
        end

        it 'is invalid without content' do
            post = Post.new(title: 'My First Post')
            expect(post).to be_invalid
        end
    end
end