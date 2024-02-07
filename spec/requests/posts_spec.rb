require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
    describe 'POST /posts' do
        let(:valid_attributes) { { title: 'My first post', content: 'Content of the post' } }

        context 'when the request is valid' do
            before { post '/posts', params: {post: valid_attributes}}

            it 'creates a new post' do
                expect {
                    post '/posts', params: { post: valid_attributes }
                }.to change(Post, :count).by(1)

            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end

            it 'returns the created post' do
                expect(json['title']).to eq('My first post')
                expect(json['content']).to eq('Content of the post')
            end

            it 'saves the post with the correct attributes' do
                post = Post.last
                expect(post.title).to eq('My first post')
                expect(post.content).to eq('Content of the post')
            end
        end

    end

    def json
        JSON.parse(response.body)
    end
end