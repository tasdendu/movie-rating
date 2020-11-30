pragma solidity ^0.5.0;

contract MovieRating {
    Movie[] movies;
    uint256[] public movieIds;
    uint256[15] public averageMovieRatings;

    event MovieRated(address _rater, uint _rating);
    event MovieInfo(uint256 _movieId, uint256 _accomulatedRating, uint256 _rateCount);
    event MovieAdded(uint256 _movieId, string _movieName);

    mapping(uint256 => mapping(address => uint)) movieRatings;
    mapping(uint256 => uint256) rateCount;
    mapping(uint256 => uint256) accumulatedRating;

    struct Movie {
        uint256 movieId;
        string movieName;
    }

    constructor() public {
        for (uint256 i = 1; i <= 15; i++) {
            AddMovie(i, string(abi.encodePacked("Movie ", i)));
        }
    }

    function AddMovie(uint256 _movieId, string memory _movieName) public returns (uint256){
        bool isExists = MovieExists(_movieId);

        require(isExists == false, "The entered movie ID already exists");

        Movie memory movie = Movie(_movieId, _movieName);
        movies.push(movie);
        movieIds.push(_movieId);

        emit MovieAdded(_movieId, _movieName);

        return _movieId;
    }

    function RateMovie(uint256 _movieId, uint _rating) public {
        bool isExists = MovieExists(_movieId);
        uint256 rate = movieRatings[_movieId][msg.sender];

        require(isExists == true, "The entered movie ID not found");
        require(_rating > 0 && _rating <= 5, "The rating should be within 1-5");

        movieRatings[_movieId][msg.sender] = _rating;

        if (rate == 0) {
            rateCount[_movieId] += 1;
            accumulatedRating[_movieId] += _rating;
        } else {
            accumulatedRating[_movieId] -= rate;
            accumulatedRating[_movieId] += _rating;
        }

        averageMovieRatings[_movieId - 1] = accumulatedRating[_movieId] / rateCount[_movieId];
        emit MovieRated(msg.sender, _rating);
    }

    function MovieExists(uint256 _movieId) private view returns (bool){
        bool isExists = false;

        for (uint256 i = 0; i < movies.length; i++) {
            if (movies[i].movieId == _movieId) {
                isExists = true;
                break;
            }
        }

        return isExists;
    }

    function TotalRating(uint256 _movieId) public view returns (uint256){
        bool isExists = MovieExists(_movieId);

        if (isExists == false || rateCount[_movieId] == 0) {
            return 0;
        }

        return accumulatedRating[_movieId] / rateCount[_movieId];
    }

    function TotalMovies() public view returns (uint256){
        uint256 total = movies.length;

        return total;
    }

    function getMovieIds() public view returns (uint256[] memory){
        return movieIds;
    }

    function getAverageMovieRatings() public view returns (uint256[15] memory) {
        return averageMovieRatings;
    }
}
