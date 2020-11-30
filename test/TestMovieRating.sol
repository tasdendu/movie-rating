pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MovieRating.sol";

contract TestMovieRating {
    // The address of the MovieRating contract to be tested
    MovieRating movieRating = MovieRating(DeployedAddresses.MovieRating());

    // The id of the pet that will be used for testing
    uint expectedMovieId = 18;

    // Testing the adopt() function
    function testUserAddMovie() public {
        uint256 returnedId = movieRating.AddMovie(expectedMovieId, 'Movie');

        Assert.equal(returnedId, expectedMovieId, "MovieRating of the expected movie should match what is returned.");
    }
}
