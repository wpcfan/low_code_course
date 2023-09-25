package com.mooc.backend.repositories;

import com.mooc.backend.entities.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.stream.Stream;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    Stream<Category> streamByParentIsNull();
}
