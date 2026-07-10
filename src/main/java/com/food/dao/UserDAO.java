package com.food.dao;

import java.util.List;
import java.util.Optional;

import com.food.model.User;

/**
 * DAO contract for {@link User} persistence operations.
 *
 * Implementations must handle session/transaction lifecycle internally.
 * Callers should never manage Hibernate sessions directly.
 */
public interface UserDAO {

    /**
     * Persists a new User to the database.
     * The User's ID will be populated by Hibernate after this call.
     *
     * @param user the transient User object to save
     */
    void addUser(User user);

    /**
     * Merges (updates) an existing User in the database.
     *
     * @param user the detached User object with updated fields
     */
    void updateUser(User user);

    /**
     * Deletes the User with the given ID. No-op if not found.
     *
     * @param userId the primary key of the User to delete
     */
    void deleteUser(int userId);

    /**
     * Returns the User for a given primary key, or {@code null} if not found.
     *
     * @param userId the primary key
     */
    User getUserById(int userId);

    /**
     * Returns all Users in the database.
     */
    List<User> getAllUsers();

    /**
     * Authenticates a user by email and password.
     *
     * @param email    the user's email
     * @param password the plain-text password (hash before storing in production!)
     * @return an {@link Optional} containing the User if credentials match, else empty
     */
    Optional<User> login(String email, String password);

    /**
     * Checks whether an email address is already registered.
     *
     * @param email the email to check
     * @return {@code true} if the email exists
     */
    boolean emailExists(String email);
}