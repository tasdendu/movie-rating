pragma solidity ^0.5.0;

contract MovieRating {
    address owner;
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
        owner = msg.sender;

        for (uint256 i = 1; i <= 15; i++) {
            addMovie(i, string(abi.encodePacked("Movie ", i)));
        }
    }

    modifier onlyOwner() {
        require(owner == msg.sender, 'Only owner can add the movie');
        _;
    }

    modifier movieExists(uint256 _movieId) {
        bool isExists = isMovieExists(_movieId);
        require(isExists == false, 'The entered movie ID already exists');
        _;
    }

    modifier movieNotExists(uint256 _movieId) {
        bool isExists = isMovieExists(_movieId);
        require(isExists == true, 'The entered movie ID not found');
        _;
    }

    modifier correctRatingValue(uint _rating) {
        require(_rating > 0 && _rating <= 5, "The rating should be within 1-5");
        _;
    }

    function addMovie(uint256 _movieId, string memory _movieName) public onlyOwner movieExists(_movieId) returns (uint256){
        Movie memory movie = Movie(_movieId, _movieName);
        movies.push(movie);

        emit MovieAdded(_movieId, _movieName);

        return _movieId;
    }

    function rateMovie(uint256 _movieId, uint _rating) public movieNotExists(_movieId) correctRatingValue(_rating) {
        uint256 rate = movieRatings[_movieId][msg.sender];

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

    function isMovieExists(uint256 _movieId) private view returns (bool){
        bool isExists = false;

        for (uint256 i = 0; i < movies.length; i++) {
            if (movies[i].movieId == _movieId) {
                isExists = true;
                break;
            }
        }

        return isExists;
    }

    function getAverageMovieRating(uint256 _movieId) public view returns (uint256){
        bool isExists = isMovieExists(_movieId);

        if (isExists == false || rateCount[_movieId] == 0) {
            return 0;
        }

        return accumulatedRating[_movieId] / rateCount[_movieId];
    }

    // Get sessions movie rating
    function getMyRating(uint256 _movieId) public view returns (uint256){
        return movieRatings[_movieId][msg.sender];
    }

    function getTotalMovies() public view returns (uint256){
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
