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
            end
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

    describe 'GET /posts' do
        let!(:posts) {create_list(:post, 10) } #creating 10 posts using Factory Bot

        before { get '/posts' }

        it 'returns posts' do
            expect(response).to have_http_status(200)
            expect(json).not_to be_empty
            expect(json.size).to eq(10)
        end

        it 'returns posts with the correct structure' do
            #Assuming each post has 'title' and 'content'
            json.each do |post|
                expect(post).to include('title', 'content')
            end
        end
    end

    describe 'GET /posts/:id' do
        let!(:post) { create(:post) }

        before { get "/posts/#{post.id}" }

        it 'returns the post' do    
            expect(response).to have_http_status(200)
            expect(json).not_to be_empty
            expect(json['id']).to eq(post.id)
        end

        it 'should have the correct structure' do
            expect(json).to include('title', 'content')
        end
    end

    describe 'PUT /posts/:id' do
        let!(:post) { create(:post) }

        context 'when the request is valid' do
            before { put "/posts/#{post.id}", params: { post: { title: 'My updated post', content: 'Updated content'} } }

            it 'updates the post' do
                expect(response).to have_http_status(200)
                expect(json['title']).to eq('My updated post')
                expect(json['content']).to eq('Updated content')
            end
        end

        context 'when the request is invalid' do
            before { put "/posts/#{post.id}", params: { post: { title: '', content: '' } } }

            it 'returns status code 422' do
                expect(response).to have_http_status(422)
            end

            it 'returns a validation failure message' do
                expect(json['title']).to include("can't be blank")
                expect(json['content']).to include("can't be blank")
            end
        end
    end

    describe 'DELETE /posts/:id' do
        let!(:post) { create(:post) }

        before { delete "/posts/#{post.id}" }

        it 'returns status code 204' do
            expect(response).to have_http_status(204)
        end
    end

    def json
        JSON.parse(response.body)
    end
end